#!/bin/bash
export NCCL_P2P_DISABLE=1
# export NCCL_SOCKET_IFNAME=ib

export DASK_DISTRIBUTED__SCHEDULER__WORK_STEALING=False
export DASK_DISTRIBUTED__SCHEDULER__BANDWIDTH=1

ENVNAME=$1
NWORKERS=$(echo $2 | cut -f1 -d,)
if [[ "-1" -eq "$NWORKERS" ]]; then
    NWORKERS=$(nvidia-smi --list-gpus | wc --lines)
fi

NUM_GPUS=$(echo $2 | cut -f2 -d,)
if [[ -z "$NUM_GPUS" ]]; then
    NUM_GPUS=$(nvidia-smi --list-gpus | wc --lines)
fi
if [[ "-1" -eq "$NUM_GPUS" ]]; then
    NUM_GPUS=$(nvidia-smi --list-gpus | wc --lines)
fi
if [[ "0" -lt "$NUM_GPUS" ]] && [[ "$NWORKERS" -gt "$NUM_GPUS" ]]; then
    NWORKERS=$NUM_GPUS
fi
if [[ "0" -lt "$NUM_GPUS" ]] && [[ "$NWORKERS" -lt "$NUM_GPUS" ]]; then
    NWORKERS=$NUM_GPUS
fi

DASK_SCHED_PORT=$3
DASK_SCHED_BOKEH_PORT=$4
DASK_WORKER_BOKEH_PORT=$5
MASTER_IPADDR=$6
WHOAMI=$7
DEBUG=$8

DASK_LOCAL_DIR=./.dask
MY_IPADDR=($(hostname --all-ip-addresses))

mkdir -p $DASK_LOCAL_DIR

echo -e "\n"

echo "shutting down current dask cluster if it exists..."
NUM_SCREENS=$(screen -list | grep --only-matching --extended-regexp '[0-9]\ Socket|[0-9]{1,10}\ Sockets' | grep --only-matching --extended-regexp '[0-9]{1,10}')
SCREENS=($(screen -list | grep --only-matching --extended-regexp '[0-9]{1,10}\.dask|[0-9]{1,10}\.gpu' | grep --only-matching --extended-regexp '[0-9]{1,10}'))
if [[ $NUM_SCREENS > 0 ]]; then
    screen -wipe
    for screen_id in $(seq 1 $NUM_SCREENS);
    do
    index=$screen_id-1
    echo ${SCREENS[$index]}
    screen -S ${SCREENS[$index]} -X quit
    done
fi
echo "... cluster shut down"

echo -e "\n"

if [[ "0" -lt "$NWORKERS" ]]; then

    if [[ "$WHOAMI" = "MASTER" ]]; then
        echo "initializing dask scheduler..."
        screen -dmS dask_scheduler bash -c "source activate $ENVNAME && dask-scheduler"
        sleep 5
        echo "... scheduler started"
    fi

    echo -e "\n"

    echo "starting $NWORKERS worker(s)..."
    declare -a WIDS
    for worker_id in $(seq 1 $NWORKERS);
    do
    start=$(( worker_id - 1 ))
    end=$(( NWORKERS - 1 ))
    other=$(( start - 1 ))
    devs=$(seq --separator=, $start $end)
    second=$(seq --separator=, 0 $other)
    if [ "$second" != "" ]; then
        devs="$devs,$second"
    fi
    echo "... starting dask worker $worker_id"

    if [[ "$DEBUG" = "DEBUG" ]]; then
        export create_worker="source activate $ENVNAME && \
                              cuda-memcheck dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                        --host=${MY_IPADDR[0]} --no-nanny \
                                                        --nprocs=1 --nthreads=1 \
                                                        --memory-limit=0 --name ${MY_IPADDR[0]}_dask_$worker_id \
                                                        --local-directory $DASK_LOCAL_DIR/$name"
        export logfile="${DASK_LOCAL_DIR}/dask_worker_${worker_id}_log.txt"
        env CUDA_VISIBLE_DEVICES=$devs screen -dmS dask_worker_$worker_id \
                                                   bash -c 'script -c "$create_worker" "$logfile"'
    else
        export create_worker="source activate $ENVNAME && \
                              dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                          --host=${MY_IPADDR[0]} --no-nanny \
                                          --nprocs=1 --nthreads=1 \
                                          --memory-limit=0 --name ${MY_IPADDR[0]}_dask_$worker_id \
                                          --local-directory $DASK_LOCAL_DIR/$name"
        env CUDA_VISIBLE_DEVICES=$devs screen -dmS dask_worker_$worker_id \
                             bash -c "$create_worker"
    fi

    WIDS[$id]=$!
    done
    sleep 5

    echo -e "\n"

    echo "... $NWORKERS worker(s) successfully started"

    echo -e "\n"
fi

if [[ "$NWORKERS" -eq "0" ]]; then
    NUM_SCREENS=$(screen -list | grep --only-matching --extended-regexp '[0-9]\ Socket|[0-9]{1,10}\ Sockets' | grep --only-matching --extended-regexp '[0-9]{1,10}')
    if [[ $NUM_SCREENS == "" ]]; then
        echo "cluster shut down successfully"
        echo "verifying status:"
        screen -list
    fi
fi

if [[ "0" -lt "$NWORKERS" ]]; then
    echo "printing status ..."
    echo -e "\n"
    screen -list
    echo -e "\n"
fi

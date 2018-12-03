#!/bin/bash
export NCCL_P2P_DISABLE=1
# export NCCL_SOCKET_IFNAME=ib

export DASK_DISTRIBUTED__SCHEDULER__WORK_STEALING=False
export DASK_DISTRIBUTED__SCHEDULER__BANDWIDTH=1

NWORKERS_PER_NODE=$1
DASK_SCHED_PORT=$2
DASK_SCHED_BOKEH_PORT=$3
DASK_WORKER_BOKEH_PORT=$4
MASTER_IPADDR=$5
WHOAMI=$6

DASK_LOCAL_DIR=./.dask
NUM_GPUS=$(nvidia-smi --list-gpus | wc --lines)
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

if [[ "0" -lt "$NWORKERS_PER_NODE" ]] && [[ "$NWORKERS_PER_NODE" -le "$NUM_GPUS" ]]; then

    if [[ "$WHOAMI" = "MASTER" ]]; then
        echo "initializing dask scheduler..."
        screen -dmS dask_scheduler bash -c "source activate cudf_dev && dask-scheduler"
        sleep 5
        echo "... scheduler started"
    fi

    echo -e "\n"

    echo "starting $NWORKERS_PER_NODE worker(s)..."
    declare -a WIDS
    for worker_id in $(seq 1 $NWORKERS_PER_NODE);
    do
    start=$(( worker_id - 1 ))
    end=$(( NWORKERS_PER_NODE - 1 ))
    other=$(( start - 1 ))
    devs=$(seq --separator=, $start $end)
    second=$(seq --separator=, 0 $other)
    if [ "$second" != "" ]; then
        devs="$devs,$second"
    fi
    echo "... starting gpu worker $worker_id"
    # change the following command to read "... cuda-memcheck dask-worker ..." for debugging
    export create_worker="source activate cudf_dev && \
                          dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                      --host=${MY_IPADDR[0]} --no-nanny \
                                      --nprocs=1 --nthreads=1 \
                                      --memory-limit=0 --name ${MY_IPADDR[0]}_gpu_$worker_id \
                                      --local-directory $DASK_LOCAL_DIR/$name"
    # the following specifies the location for the log files ... uncomment for debugging
    # export logfile="${DASK_LOCAL_DIR}/gpu_worker_${worker_id}_log.txt"
    env CUDA_VISIBLE_DEVICES=$devs screen -dmS gpu_worker_$worker_id \
                                   bash -c "$create_worker"
                                   # bash -c 'script -c "$create_worker" "$logfile"' # uncomment this line for debugging
    WIDS[$id]=$!
    done
    sleep 5

    echo -e "\n"

    echo "... $NWORKERS_PER_NODE worker(s) successfully started"

    echo -e "\n"
fi

if [[ "$NWORKERS_PER_NODE" -eq "0" ]]; then
    NUM_SCREENS=$(screen -list | grep --only-matching --extended-regexp '[0-9]\ Socket|[0-9]{1,10}\ Sockets' | grep --only-matching --extended-regexp '[0-9]{1,10}')
    if [[ $NUM_SCREENS == "" ]]; then
        echo "cluster shut down successfully"
        echo "verifying status:"
        screen -list
    fi
fi

if [[ "0" -lt "$NWORKERS_PER_NODE" ]]; then
    echo "printing status ..."
    echo -e "\n"
    screen -list
    echo -e "\n"
fi

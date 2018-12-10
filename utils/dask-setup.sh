#!/bin/bash

export DASK_DISTRIBUTED__SCHEDULER__WORK_STEALING=False
export DASK_DISTRIBUTED__SCHEDULER__BANDWIDTH=1

ENVNAME=$1
ARCH=$2
NWORKERS=$3
DASK_SCHED_PORT=$4
DASK_SCHED_BOKEH_PORT=$5
DASK_WORKER_BOKEH_PORT=$6
MASTER_IPADDR=$7
WHOAMI=$8
LOG=$9

DASK_LOCAL_DIR=./.dask
NUM_GPUS=$(nvidia-smi --list-gpus | wc --lines)
MY_IPADDR=($(hostname --all-ip-addresses))

mkdir -p $DASK_LOCAL_DIR

echo -e "\n"

echo "shutting down current dask cluster if it exists..."
NUM_SCREENS=$(screen -list | grep --only-matching --extended-regexp '[0-9]\ Socket|[0-9]{1,10}\ Sockets' | grep --only-matching --extended-regexp '[0-9]{1,10}')
SCREENS=($(screen -list | grep --only-matching --extended-regexp '[0-9]{1,10}\.dask|[0-9]{1,10}\.cpu|[0-9]{1,10}\.gpu' | grep --only-matching --extended-regexp '[0-9]{1,10}'))
if [[ "$NUM_SCREENS" != "" ]]; then
    screen -wipe
    for screen_id in $(seq 1 $NUM_SCREENS)
    do
        index=$screen_id-1
        echo ${SCREENS[$index]}
        screen -S ${SCREENS[$index]} -X quit
    done
fi
echo "... cluster shut down"

echo -e "\n"

if [[ "$ARCH" = "GPU" ]]; then

    if [[ "$NWORKERS" -ge "$NUM_GPUS" ]]; then
        
        echo -e "\n"
        echo "[error] the number of workers must be less than or equal to the number of GPUs"
        echo -e "\n"
    
    fi

    if [[ "0" -lt "$NWORKERS" ]] && [[ "$NWORKERS" -le "$NUM_GPUS" ]]; then

        if [[ "$WHOAMI" = "MASTER" ]]; then

            echo "initializing dask scheduler..."
            screen -dmS dask_scheduler bash -c "source activate $ENVNAME && dask-scheduler"
            sleep 5
            echo "... scheduler started"

        fi

        echo -e "\n"
        echo "starting $NWORKERS worker(s)..."

        for worker_id in $(seq 1 $NWORKERS)
        do
            start=$(( worker_id - 1 ))
            end=$(( NWORKERS - 1 ))
            other=$(( start - 1 ))
            devs=$(seq --separator=, $start $end)
            second=$(seq --separator=, 0 $other)
            if [[ "$second" != "" ]]; then
                devs="$devs,$second"
            fi

            echo "... starting gpu worker $worker_id"
            
            if [[ "$LOG" = "DEBUG" ]]; then
                export NCCL_DEBUG=WARN
                export create_worker="source activate $ENVNAME && \
                                      cuda-memcheck dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                                --host=${MY_IPADDR[0]} --no-nanny \
                                                                --nprocs=1 --nthreads=1 \
                                                                --memory-limit=0 --name ${MY_IPADDR[0]}_gpu_$worker_id \
                                                                --local-directory $DASK_LOCAL_DIR/$name"
                export logfile="${DASK_LOCAL_DIR}/${MY_IPADDR[0]}_gpu_${worker_id}_log.txt"
                env CUDA_VISIBLE_DEVICES=$devs screen -dmS gpu_worker_$worker_id \
                                                           bash -c 'script --flush --command "$create_worker" "$logfile"'
            elif [[ "$LOG" = "INFO" ]]; then
                export NCCL_DEBUG=INFO
                export create_worker="source activate $ENVNAME && \
                                      dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                  --host=${MY_IPADDR[0]} --no-nanny \
                                                  --nprocs=1 --nthreads=1 \
                                                  --memory-limit=0 --name ${MY_IPADDR[0]}_gpu_$worker_id \
                                                  --local-directory $DASK_LOCAL_DIR/$name"
                export logfile="${DASK_LOCAL_DIR}/${MY_IPADDR[0]}_gpu_${worker_id}_log.txt"
                env CUDA_VISIBLE_DEVICES=$devs screen -dmS gpu_worker_$worker_id \
                                                           bash -c 'script --flush --command "$create_worker" "$logfile"'
            else
                export create_worker="source activate $ENVNAME && \
                                      dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                  --host=${MY_IPADDR[0]} --no-nanny \
                                                  --nprocs=1 --nthreads=1 \
                                                  --memory-limit=0 --name ${MY_IPADDR[0]}_gpu_$worker_id \
                                                  --local-directory $DASK_LOCAL_DIR/$name"
                env CUDA_VISIBLE_DEVICES=$devs screen -dmS gpu_worker_$worker_id \
                                                           bash -c "$create_worker"
            fi
            
        done
    fi
fi

if [[ "$ARCH" = "CPU" ]]; then

    if [[ "0" -le "$NWORKERS" ]]; then

        if [[ "$WHOAMI" = "MASTER" ]]; then

            echo "initializing dask scheduler..."
            screen -dmS dask_scheduler bash -c "source activate $ENVNAME && dask-scheduler"
            sleep 5
            echo "... scheduler started"

        fi

        echo -e "\n"
        echo "starting $NWORKERS worker(s)..."

        for worker_id in $(seq 1 $NWORKERS)
        do
            echo "... starting cpu worker $worker_id"
            if [[ "$LOG" = "DEBUG" ]]; then
                echo -e "\n"
                echo "[error] please set log-level to INFO. DEBUG log-level is only supported on GPU architectures"
                echo -e "\n"
                break
            elif [[ "$LOG" = "INFO" ]]; then
                export create_worker="source activate $ENVNAME && \
                                      dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                  --host=${MY_IPADDR[0]} --no-nanny \
                                                  --nprocs=1 --nthreads=1 \
                                                  --memory-limit=0 --name ${MY_IPADDR[0]}_cpu_$worker_id \
                                                  --local-directory $DASK_LOCAL_DIR/$name"
                export logfile="${DASK_LOCAL_DIR}/${MY_IPADDR[0]}_cpu_${worker_id}_log.txt"
                screen -dmS cpu_worker_$worker_id \
                                bash -c 'script --flush --command "$create_worker" "$logfile"'
            else
                export create_worker="source activate $ENVNAME && \
                                      dask-worker $MASTER_IPADDR:$DASK_SCHED_PORT \
                                                  --host=${MY_IPADDR[0]} --no-nanny \
                                                  --nprocs=1 --nthreads=1 \
                                                  --memory-limit=0 --name ${MY_IPADDR[0]}_cpu_$worker_id \
                                                  --local-directory $DASK_LOCAL_DIR/$name"
                screen -dmS cpu_worker_$worker_id \
                                bash -c "$create_worker"
            fi

        done
    fi
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

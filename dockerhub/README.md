## Real-time Acceleration Platform for Integrated Data Science

* * *

## What is RAPIDS?

Visit [rapids.ai](http://rapids.ai) for more information.

The RAPIDS suite of software libraries gives you the freedom to execute end-to-end data science and analytics pipelines entirely on GPUs. It relies on NVIDIA® CUDA® primitives for low-level compute optimization, but exposes that GPU parallelism and high-bandwidth memory speed through user-friendly Python interfaces.

* * *

## Prerequisites

*   GPU support
    *   Compute Capability 6.0 (Pascal Architecture) or higher
*   CUDA support
    *   9.2 or newer
*   OS support
    *   Ubuntu 16.04 LTS (tested and confirmed working)
*   Docker support
    *   [Docker CE v18+](https://docs.docker.com/install/linux/docker-ce/ubuntu/) - _apt for Ubuntu 16.04 **doesn't** include v18+ by default_
    *   [nvidia-docker v2+](https://github.com/nvidia/nvidia-docker/wiki/Installation-%28version-2.0%29)

* * *

## Available Tags

* `cuda9.2_ubuntu1604` - CUDA 9.2, Ubuntu 16.04
    *  Based off of `nvidia/cuda:9.2-devel-ubuntu16.04`.
    *  All code projects compiled with `nvcc` version 9.2.
    *  Python 3.5 and gcc5.

* `cuda10.0_ubuntu1604` - CUDA 10.0, Ubuntu 16.04
    *  Based off of `nvidia/cuda:10.0-devel-ubuntu16.04`.
    *  All code projects compiled with `nvcc` version 10.0.
    *  Python 3.5 and gcc5.

* _Coming soon_ - more tags supporing CUDA 10 and Ubuntu 18.04

* * *

## Usage

1.  First launch an interactive session:

        docker run --runtime=nvidia \
                --rm -it \
                -p 8888:8888 \
                -p 8787:8787 \
                -p 8786:8786 \
                rapidsai/rapidsai:ubuntu1604_cuda92_py35

2.  Activate the `rapids` conda environment:

        source activate rapids

3.  Download the mortgage dataset, following the instructions provided at https://rapidsai.github.io/demos/docs/datasets/2018-12-05-mortgage-dataset/

    You will need to update paths and years in the notebook (see below) depending on which subset of the mortgage data you download and where you install it.

4.  Launch the JupyterLab environment with

        bash /rapids/utils/start_jupyter.sh

5.  Open your web browser, and navigate to  
    `{IPADDR}:8888` (e.g.) `12.34.567.89:8888`  
    Note: the IP address can be found using `ifconfig` or `hostname --all-ip-addresses`. It is the address of the primary networking device. Using the IP address of the device in the Docker container will not work.

In `/rapids/notebooks` there are example notebooks, including one called `E2E.ipynb` that runs end-to-end ETL and machine learning on the provided data using RAPIDS. Be sure to `Restart the Kernel`

You are free to modify the above steps. For example, you can launch an interactive session with your own data:

    docker run --runtime=nvidia \
               --rm -it \
               -p 8888:8888 \
               -p 8787:8787 \
               -p 8786:8786 \
               -v /path/to/host/data:/rapids/my_data
               rapidsai/rapidsai:ubuntu1604_cuda92_py35

This will map data from your host operating system to the container OS in the `/rapids/my_data` directory. You may need to modify the provided notebooks for the new data paths. 

You can check the documentation for RAPIDS APIs inside the JupyterLab notebook using a `?` command, like this:

    [1] ?cudf.read_csv

This prints the function signature and its usage documentation. If this is not enough, you can see the full code for the function using `??`:

    [1] ??pygdf.read_csv

Check out the RAPIDS [documentation](http://rapids.ai/documentation.html) for more detailed information.

* * *

## Changing How Much Data is Used

In the notebook, you should see a cell like this:

    acq_data_path = "/rapids/data/mortgage/acq"
    perf_data_path = "/rapids/data/mortgage/perf"
    col_names_path = "/rapids/data/mortgage/names.csv"
    start_year = 2000
    end_year = 2002 # end_year is not inclusive
    part_count = 11 # the number of data files to train against

These are the paths to data, the number of years on which to perform ETL, and the number of parts to use for training.

Note: the entire mortgage dataset is 68 quarters, broken into 112 parts so that each part is (on average) 1.7GB. Reducing the number of parts, `part_count`, reduces how much data is input to XGBoost training. Adjusting the `start_year` and`end_year` changes how many years on which to perform ETL.

* * *

## Useful Tips and Tools for Monitoring and Debugging

### The Dask Dashboard. 

This cell from the notebook

    import subprocess

    cmd = "hostname --all-ip-addresses"
    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()
    IPADDR = str(output.decode()).split()[0]
    _client = IPADDR + str(":8786")

    client = dask.distributed.Client(_client)
    client

initializes the Dask client. Once done, you should see output like

    Client

    Scheduler: tcp://172.17.0.3:8786
    Dashboard: http://172.17.0.3:8787/status
    Cluster

    Workers: 8
    Cores: 8
    Memory: 0 B

Note: clicking `Dashboard: http://172.17.0.3:8787/status`  may not work. The IP address in the link may be the networking device in the container. You have to use the IP address of the primary networking device, which should be the one you used to access the Jupyter notebook server. `http://your.ip.address:8787/status`

Once there, you can look at active processes, view the (delayed) task graph, and read through individual worker logs.

### Individual Worker Logs

When you hit an unusual error, there are often traces of the error in the individual worker logs accessible from the Dashboard status page (see above). CUDA out-of-memory errors will show up here.

* * *

## Common Errors

### Running out of device memory

ETL processes may involve creating many copies of data in device memory, resulting in sporadic spikes of memory utilization. Memory utilization which exceeds available device resources will cause the worker to crash.

Because we have disabled experimental features that would enable the worker to recover, restart its work, or share its work with other workers, the error is silently propagated forward in the Dask's delayed task graph. This can manifest itself in the form of unusually short ETL times (sub-millisecond timescale).

An error may be raised by another routine referring to `NoneType` in `data` or similar

Training processes need a certain amount of available memory to expand throughout processing. With XGBoost, the overhead is typically 25% of available device memory. This means that we cannot exceed 24GB of memory utilization on a 32GB GPU, or 12GB of memory utilization on a 16GB GPU.

### Running out of system memory

The final step of the ETL process migrates all computed results back to system memory before training, and if you do not have sufficient system memory, your program will crash. The step before training migrates a portion of the data back into device memory for XGBoost to train against.

* * *

## Where can I get help or file bugs/requests?

Please submit issues with the container to this GitHub repository: [https://github.com/rapidsai/cudf](https://github.com/rapidsai/cudf)
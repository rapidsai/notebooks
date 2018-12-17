# Utility Scripts

## Summary

* `start-jupyter.sh`: starts a JupyterLab environment for interacting with, and running, notebooks
* `stop-jupyter.sh`: identifies all process IDs associated with Jupyter and kills them
* `dask-cluster.py`: launches a configured Dask cluster (a set of nodes) for use within a notebook
* `dask-setup.sh`: a low-level script for constructing a set of Dask workers on a single node
* `split-data-mortgage.sh`: splits mortgage data files into smaller parts, and saves them for use with the mortgage notebook

## start-jupyter

Typical output for `start-jupyter.sh` will be of the following form:

```bash

jupyter-lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token=''


[I 09:58:01.481 LabApp] Writing notebook server cookie secret to /run/user/10060/jupyter/notebook_cookie_secret
[W 09:58:01.928 LabApp] All authentication is disabled.  Anyone who can connect to this server will be able to run code.
[I 09:58:01.945 LabApp] JupyterLab extension loaded from /conda/envs/cudf/lib/python3.6/site-packages/jupyterlab
[I 09:58:01.945 LabApp] JupyterLab application directory is /conda/envs/cudf/share/jupyter/lab
[W 09:58:01.946 LabApp] JupyterLab server extension not enabled, manually loading...
[I 09:58:01.949 LabApp] JupyterLab extension loaded from /conda/envs/cudf/lib/python3.6/site-packages/jupyterlab
[I 09:58:01.949 LabApp] JupyterLab application directory is /conda/envs/cudf/share/jupyter/lab
[I 09:58:01.950 LabApp] Serving notebooks from local directory: /workspace/notebooks/notebooks
[I 09:58:01.950 LabApp] The Jupyter Notebook is running at:
[I 09:58:01.950 LabApp] http://(dgx15 or 127.0.0.1):8888/
[I 09:58:01.950 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```

`jupyter-lab` will expose a JupyterLab server on port `:8888`. Opening a web-browser, and navigating to `http://YOUR.IP.ADDRESS:8888` provides a GUI which can used to edit/run code.

## stop-jupyter

Sometimes a server needs to be forcibly shut down. Running 

```bash
notebooks$ bash utils/stop-jupyter.sh
```

will kill any and all JupyterLab servers running on the machine.

## dask-cluster

This is a Python script used to launch a Dask cluster. A configuration file is provided at `/path/to/notebooks/utils/dask.conf`.

```bash
notebooks$ cat utils/dask.conf

ENVNAME cudf

ARCH GPU

NWORKERS 8

12.34.567.890 MASTER

DASK_SCHED_PORT         8786
DASK_SCHED_BOKEH_PORT   8787
DASK_WORKER_BOKEH_PORT  8790

LOG DEBUG
```

* `ENVNAME cudf`: a keyword to tell `dask-cluster.py` the name of the virtual environment where `cudf` is installed
* `ARCH GPU`: a keyword to tell `dask-cluster.py` to instantiate GPU workers (or CPU workers if `CPU` is given)
* `NWORKERS 8`: a keyword to tell `dask-cluster.py` how many workers to instantiate on the node which called `dask-cluster.py`
* `12.34.567.890 MASTER`: a map of `IP.ADDRESS {WORKER/MASTER}`
* `DASK_SCHED_PORT         8786`: a keyword to tell `dask-cluster.py` which port is assigned to the Dask scheduler
* `DASK_SCHED_BOKEH_PORT   8787`: a keyword to tell `dask-cluster.py` which port is assigned to the scheduler's visual front-end
* `DASK_WORKER_BOKEH_PORT  8790`: a keyword to tell `dask-cluster.py` which port is assigned to the worker's visual front-end
* `LOG DEBUG`: a keyword to tell `dask-cluster.py` to launch all Dask workers with log-level set to DEBUG (or INFO if `INFO` is given)

## dask-setup

`dask-setup.sh` is designed to be called by `dask-cluster.py`. It is not meant to be called directly by a user other than to kill all present Dask workers:

```bash
notebooks$ bash utils/dask-setup.sh 0
```

`dask-setup.sh` expects several inputs, and order matters:

* `ENVNAME`: name of the virtual environment where `cudf` is installed
* `ARCH`: type of workers to create (`CPU` or `GPU`)
* `NWORKERS`: number of workers to create
* `DASK_SCHED_PORT`: port to assign the scheduler
* `DASK_SCHED_BOKEH_PORT`: port to assign the scheduler's front-end
* `DASK_WORKER_BOKEH_PORT`: port to assign the worker's front-end
* `YOUR.IP.ADDRESS`: machine's IP address
* `{WORKER/MASTER}`: the node's title
* `LOG`: log-level (optional, case-sensitive). Valid entries include `INFO`, `DEBUG`

The script is called as follows:

```bash
notebooks$ bash utils/dask-setup.sh 8 8786 8787 8790 12.34.567.890 MASTER DEBUG
```

Note: `LOG` is an optional argument.

## split-data-mortgage

`split-data-mortgage.sh` is designed to accept a single argument: `SIZE`. `SIZE` is an integral value specifying the target partition file size. Because this script uses `split`, `SIZE` may also have units (K, M, G, T, P, E, Z, Y ... powers of 1024; KB, MB, ... powers of 1000) (e.g.) `10K == 10 * 1024`

You must update the paths to data near the beginning of the script:

```bash
#!/bin/bash
set -e

SRC="/path/to/mortgage/perf_old"
DST="/path/to/mortgage/perf_new"
WORK="/path/to/mortgage/"
```

* `SRC`: path to the original mortgage data files
* `DST`: path to save the split files
* `WORK`: working directory (where both data directories will be visible)

Note: this script corrects for record spilling (when a record data appears in two files). Here's some sample output:

```bash 
[Mon Dec 17 23:14:44 UTC 2018] Processing Performance_2003Q3.txt_1_0_0
[Mon Dec 17 23:14:44 UTC 2018]   Sorting...
[Mon Dec 17 23:15:03 UTC 2018]   Splitting...
[Mon Dec 17 23:15:22 UTC 2018]   Split into 2 files
[Mon Dec 17 23:15:30 UTC 2018]   Checking for spill...
[Mon Dec 17 23:15:30 UTC 2018]     >>Spill detected, correcting<<
```

The script follows this procedure:
1. Sort the data in the file
2. Split the file into `N` parts which are not larger than `SIZE`
3. Check each file partition for record spillage
4. If records spilled, correct them by aggregating the spilled record to a single file partition
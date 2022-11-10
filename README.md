# RAPIDS Notebooks

## Intro

These notebooks provide examples of how to use RAPIDS.  These notebooks are designed to be self-contained with the `runtime` version of the [RAPIDS Docker Container](https://hub.docker.com/r/rapidsai/rapidsai/) and [RAPIDS Nightly Docker Containers](https://hub.docker.com/r/rapidsai/rapidsai-nightly) and can run on air-gapped systems.  You can quickly get this container using the install guide from the [RAPIDS.ai Getting Started page](https://rapids.ai/start.html#get-rapids)

## Quick Start

- [10 Minutes to cuDF](cudf/10min.ipynb) - Intro to GPU Accelerated Dataframes and ETL using [cuDF](https://github.com/rapidsai/cudf)
- [Estimator Intro](cuml/estimator_intro.ipynb) - Intro to GPU Accelerated Machine Learning using [cuML](https://github.com/rapidsai/cuml)
- [10 Minutes to cuGraph]() - GPU Accelerated Graph Analytics using [cuSpatial](https://github.com/rapidsai/cugraph)
- [10 Minutes to cuXFilter](cuxfilter/10_minutes_to_cuxfilter.ipynb) - Intro to GPU Accelerated, Interactive Data Visualations using [cuXFilter](https://github.com/rapidsai/cuxfilter)
- [cuSpatial API Examples]() - Intro to GPU Accelerated Spatial Analytics using [cuSpatial](https://github.com/rapidsai/cusignal)
- [10 Minutes to cuSignal]() - Intro to GPU Accelerated Signal Analytics using [cuSignal](https://github.com/rapidsai/cusignal)
- [10 Minutes to CLX](cuxfilter/10minu.ipynb) - Intro to Cyber Security Log Analytics using [CLX](https://github.com/rapidsai/cls) (if installed)

## Usage

This repository serves as a convenience for our developers and users as a colocation of all RAPIDS notebooks.

To get the latest notebook repo updates, run `./update.sh` or use the following command:

`git submodule update --init --remote --no-single-branch --depth 1`

## Repo Notebook Folder Locations

- [cuDF Notebooks](https://github.com/rapidsai/cudf/tree/branch-22.10/notebooks)
- [cuML Notebooks](https://github.com/rapidsai/cuml/tree/branch-22.10/notebooks)
- [cuGraph Notebooks](https://github.com/rapidsai/cugraph/tree/branch-22.10/notebooks)
- [cuSpatial Notebooks](https://github.com/rapidsai/cuspatial/tree/branch-22.10/notebooks)
- [cuSignal Notebooks](https://github.com/rapidsai/cusignal/tree/branch-22.10/notebooks)
- [cuxfilter Notebooks](https://github.com/rapidsai/cuxfilter/tree/branch-22.10/notebooks)
- [XGBoost Notebooks](https://github.com/rapidsai/xgboost-conda/tree/branch-22.10/notebooks)
- [CLX Notebooks](https://github.com/rapidsai/clx/tree/branch-22.10/notebooks) (if installed)

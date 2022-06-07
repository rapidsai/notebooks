# RAPIDS Notebooks

- [cuML Notebooks](https://github.com/rapidsai/cuml/tree/branch-22.06/notebooks)
- [cuGraph Notebooks](https://github.com/rapidsai/cugraph/tree/branch-22.06/notebooks)
- [CLX Notebooks](https://github.com/rapidsai/clx/tree/branch-22.06/notebooks)
- [cuSpatial Notebooks](https://github.com/rapidsai/cuspatial/tree/branch-22.06/notebooks)
- [cuxfilter Notebooks](https://github.com/rapidsai/cuxfilter/tree/branch-22.06/notebooks)
- [XGBoost Notebooks](https://github.com/rapidsai/xgboost-conda/tree/branch-22.06/notebooks)

## Intro

These notebooks provide examples of how to use RAPIDS.  These notebooks are designed to be self-contained with the `runtime` version of the [RAPIDS Docker Container](https://hub.docker.com/r/rapidsai/rapidsai/) and [RAPIDS Nightly Docker Containers](https://hub.docker.com/r/rapidsai/rapidsai-nightly) and can run on air-gapped systems.  You can quickly get this container using the install guide from the [RAPIDS.ai Getting Started page](https://rapids.ai/start.html#get-rapids)

## Usage

This repository serves as a convenience for our developers and users as a colocation of all RAPIDS notebooks.

To get the latest notebook repo updates, run `./update.sh` or use the following command:

`git submodule update --init --remote --no-single-branch --depth 1`

#!/bin/bash
set -e

THIS_DIR=$(dirname $(readlink -f "$0"))
NBTEST=$(readlink -f "${THIS_DIR}/nbtest.sh")
NOTEBOOKS_DIR=$(readlink -f "${THIS_DIR}/..")
LIBCUDF_KERNEL_CACHE_PATH=${WORKSPACE}/.jitcache

# Add notebooks that should be skipped here
# (space-separated list of filenames without paths)
SKIPNBS="cuml_benchmarks.ipynb uvm.ipynb bfs_benchmark.ipynb louvain_benchmark.ipynb pagerank_benchmark.ipynb sssp_benchmark.ipynb
         release.ipynb nx_cugraph_bc_benchmarking.ipynb sdr_integration.ipynb sdr_wfm_demod.ipynb io_examples.ipynb E2E_Example.ipynb random_walk_perf.ipynb"

## Check env
env

EXITCODE=0

# Download cugraph datasets if they don't already exist
(cd "${NOTEBOOKS_DIR}"/cugraph; ./cugraph_benchmarks/dataPrep.sh)


for NB_PATH in $(find "${NOTEBOOKS_DIR}"/repos/*/notebooks/* -name *.ipynb); do
    nbBaseName=$(basename "${NB_PATH}")
    nbDirName=$(dirname "${NB_PATH}")

    # Extracts <repo> (i.e. xgboost) from an absolute path like this:
    # /rapids/notebooks/repos/xgboost/notebooks/XGBoost_Demo.ipynb
    nbRepo=$(echo "${NB_PATH}" | sed -e "s|^$NOTEBOOKS_DIR/repos/||" -e "s|/notebooks.*$||")

    echo "========================================"
    echo "REPO: ${nbRepo}"
    echo "========================================"

    # Skip all NBs that use dask (in the code or even in their name)
    if echo "${NB_PATH}" | grep -qi dask || grep -q dask "${NB_PATH}"; then
        echo "--------------------------------------------------------------------------------"
        echo "SKIPPING: ${NB_PATH} (suspected Dask usage, not currently automatable)"
        echo "--------------------------------------------------------------------------------"
    elif (echo " ${SKIPNBS} " | grep -q " ${nbBaseName} "); then
        echo "--------------------------------------------------------------------------------"
        echo "SKIPPING: ${NB_PATH} (listed in skip list)"
        echo "--------------------------------------------------------------------------------"
    # Skip CLX notebooks since they are not part of the runtime images
    elif [[ ${nbRepo} == "clx" ]]; then
        echo "--------------------------------------------------------------------------------"
        echo "SKIPPING: ${NB_PATH} (CLX notebook)"
        echo "--------------------------------------------------------------------------------"
    else
        # cd into notebooks directory to account for relative dataset paths
        cd "${nbDirName}"
        nvidia-smi
        set +e
        ${NBTEST} "${NB_PATH}"
        EXITCODE=$((EXITCODE | $?))
        set -e
        rm -rf "${LIBCUDF_KERNEL_CACHE_PATH}"/*
    fi
done

nvidia-smi

exit ${EXITCODE}

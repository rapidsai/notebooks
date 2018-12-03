#!/bin/bash

export PYTHON_VERSION=3.6
export NUMBA_VERSION=0.40.0
export NUMPY_VERSION=1.14.5
export PANDAS_VERSION=0.20.3
export PYARROW_VERSION=0.10

echo -e "\n"                                                                            
echo "attempting to remove current conda environment cudf"                              
conda-env   remove  --name cudf  --quiet --yes                                          
echo "creating dev environment for cudf"                                                
echo -e "\n"                                                                            
conda       update  --name base --yes conda                                          && \
conda       install --yes  python=$PYTHON_VERSION                                    && \
conda       create  --name cudf  --yes python=$PYTHON_VERSION                        && \
conda       install --name cudf  --yes --channel conda-forge                            \
                                      --channel numba                                   \
                                      --channel nvidia                                  \
                                      nvstrings                                         \
                                      bokeh                                             \
                                      cmake                                             \
                                      dask                                              \
                                      pytest                                            \
                                      pycparser                                         \
                                      cffi                                              \
                                      cython                                            \
                                      jupyterlab                                        \
                                      numba=$NUMBA_VERSION                              \
                                      numpy=$NUMPY_VERSION                              \
                                      numpy-base=$NUMPY_VERSION                         \
                                      pandas=$PANDAS_VERSION                            \
                                      pyarrow=$PYARROW_VERSION                          \
                                      scikit-learn                                      \
                                      scipy                                          && \
conda       clean   --all       --yes                                                && \
echo -e "\n"                                                                         && \
echo "successfully created environment cudf"                                         && \
echo -e "\n"

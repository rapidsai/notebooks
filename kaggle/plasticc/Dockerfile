# An integration test & dev container which builds and installs cuDF from master
ARG CUDA_VERSION=9.2
ARG LINUX_VERSION=ubuntu16.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
# Needed for pygdf.concat(), avoids "OSError: library nvvm not found"
ENV NUMBAPRO_NVVM=/usr/local/cuda/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda/nvvm/libdevice/


# Install conda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
RUN sh /miniconda.sh -b -p /conda && /conda/bin/conda update -n base conda
ENV PATH=${PATH}:/conda/bin
# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

RUN conda create --name cudf 
RUN apt-get update -y && apt-get install -y curl unzip vim
RUN source activate cudf && \
  conda install -c nvidia -c rapidsai -c numba -c conda-forge -c defaults cudf=0.5 python=3.6
RUN source activate cudf && \
  pip install xgboost seaborn scikit-learn termcolor kaggle

RUN source activate cudf && \
  conda install -y jupyter notebook

ADD notebooks /notebooks
WORKDIR /notebooks
RUN mv .kaggle ~/
RUN chmod 600 /root/.kaggle/kaggle.json
ADD data /data
WORKDIR /data
RUN source activate cudf && kaggle competitions download -c PLAsTiCC-2018
WORKDIR /data
RUN unzip "*.zip"
WORKDIR /notebooks

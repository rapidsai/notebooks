# 1. Introduction
These notebokks demo the single GPU model of 8th place [Rapids.ai](https://rapids.ai) solution of [PLAsTiCC Astronomical Classification](https://www.kaggle.com/c/PLAsTiCC-2018). The full blog can be found [here](https://medium.com/rapids-ai/make-sense-of-the-universe-with-rapids-ai-d105b0e5ec95).

# 2. Build and run the docker demo

## Build Docker from gitlab clone
```bash
$ git clone https://github.com/daxiongshu/notebooks 
$ cd notebooks
$ git checkout remotes/origin/kaggle
$ cd kaggle/plasticc
$ docker build --tag plasticc_demo .
```

## Run Docker notebooks
```bash
$ docker run -p 8888:8888 --runtime=nvidia -it plasticc_demo bash
$ source activate cudf
$ jupyter notebook --ip '0.0.0.0' --allow-root
```

# 3. Build and run with bare-metal conda install
## Requirement
1. cuda>=9.2
2. anaconda

## Install depencencies
```bash
$ conda create -n cudf python=3.6
$ source activate cudf
$ conda install -c nvidia -c rapidsai -c numba -c conda-forge -c defaults cudf=0.5 python=3.6
$ pip install xgboost seaborn termcolor scikit-learn
$ conda install jupyter notebook
```  

## Download data
Download data from [link](https://www.kaggle.com/c/PLAsTiCC-2018/data) and uncompress to the `data` folder. 

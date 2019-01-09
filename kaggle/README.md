## <div align="left"><img src="img/rapids_logo.png" width="265px"/></div> Open GPU Data Science

# Introduction
This repo contains rapids solutions for kaggle competitions.
1. rapids\_lsst\_demo.ipynb: 8th place [Rapids.ai](https://rapids.ai) solution of [PLAsTiCC Astronomical Classification](https://www.kaggle.com/c/PLAsTiCC-2018).  

# Setup
## Requirement
1. cuda>=9.2
2. anaconda

## Install depencencies
```bash
$ conda create -n cudf-latest python=3.6
$ source activate cudf-latest
$ conda install -c nvidia -c rapidsai -c numba -c conda-forge -c defaults cudf=0.4.0
$ pip install xgboost
$ pip install scikit-learn
$ conda install jupyter notebook
```


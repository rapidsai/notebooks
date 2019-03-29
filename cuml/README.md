# cuML Notebooks

## Summary

* `dbscan_demo`: notebook showcasing density-based spatial clustering of applications with noise (dbscan) algorithm comparison between cuML and scikit-learn.
* `knn_demo`: notebook showcasing k-nearest neighbors (knn) algorithm comparison between cuML and scikit-learn.
* `pca_demo`: notebook showcasing principal component analysis (PCA) algorithm comparison between cuML and scikit-learn.
* `tsvd_demo`: notebook showcasing truncated singular value decomposition (tsvd) algorithm comparison between cuML and scikit-learn.
* `linear_regression`: notebook showcasing linear regression comparison between cuML and scikit-learn.
* `ridge_regression`: notebook showcasing ridge regression comparison between cuML and scikit-learn.
* `sgd`: notebook showcasing ridge regression comparison between cuML and scikit-learn.
* `umap`: notebook showcasing and evaluating cuML's UMAP dimension reduction technique.

## dbscan_demo

Typical output of the cells processing dbscan looks like:

- For scikit-learn dbscan:
```
CPU times: user 25.9 s, sys: 315 ms, total: 26.2 s
Wall time: 26.2 s
```

- For cuML dbscan:
```
CPU times: user 6.02 s, sys: 19.7 ms, total: 6.04 s
Wall time: 6.11 s
```

Final cell of the notebook should output:

```
compare dbscan: cuml vs sklearn labels_ equal
```

Note that the timing differences depend upon the exact dataset being used. Also, the dbscan algorithm implemented in version 0.4.0 of cuML is equivalent to `algorithm=brute` in [scikit-learn](https://scikit-learn.org/stable/modules/generated/sklearn.cluster.DBSCAN.html)

## knn_demo

The `knn_demo` notebook demonstrates how cuml establishes interoperability between `cudf` and `faiss-gpu`. There is native support for this demo with CUDA 9.2. With CUDA 10.0, the user must build `faiss-gpu` from source with [GPU support](https://github.com/facebookresearch/faiss/blob/master/INSTALL.md).

Typical output of the cells processing knn looks like:

- For scikit-learn knn:
```
CPU times: user 3min 47s, sys: 87 ms, total: 3min 47s
Wall time: 3min 47s
```

- For cuML/faiss knn:
```
CPU times: user 137 ms, sys: 164 ms, total: 302 ms
Wall time: 399 ms
```

Final cell of the notebook should output:

```
compare knn: cuml vs sklearn distances equal
compare knn: cuml vs sklearn indexes NOT equal
```

Note that the indexes can differ currently between results, but distances should be equal.

## pca_demo

Typical output of the cells processing pca looks like:

- For scikit-learn pca:
```
CPU times: user 3min 35s, sys: 43.3 s, total: 4min 18s
Wall time: 44.8 s
```

- For cuML pca:
```
CPU times: user 1.18 s, sys: 220 ms, total: 1.4 s
Wall time: 1.4 s
```

Final cell of the notebook should output:

```
compare pca: cuml vs sklearn transformed results equal
```

## tsvd_demo

Typical output of the cells processing tsvd looks like:

- For scikit-learn pca:
```
CPU times: user 12.5 s, sys: 2.97 s, total: 15.5 s
Wall time: 2.76 s
```

- For cuML pca:
```
CPU times: user 605 ms, sys: 296 ms, total: 901 ms
Wall time: 924 ms
```

Final cell of the notebook should output:

```
compare tsvd: cuml vs sklearn transformed results equal
```

## linear_regression_demo

Typical output of the cells processing linear_regression looks like:

- For scikit-learn:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

- For cuML:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

Final cell of the notebook should output:

```
SKL MSE(y):
3.4750864e-13
CUML MSE(y):
5.827862e-07
```

## ridge_regression_demo

Typical output of the cells processing ridge_regression looks like:

- For scikit-learn:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

- For cuML:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

Final cell of the notebook should output:

```
SKL MSE(y):
1.8886121326984265e-08
CUML MSE(y):
1.9204549e-08
```

## sgd_demo

Typical output of the cells processing sgd looks like:

- For scikit-learn:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

- For cuML:
```
CPU times: user  s, sys:  s, total:  s
Wall time:  s
```

Final cell of the notebook should output:

```
SKL MSE(y):
1.1356839999498491e-07
CUML MSE(y):
1.04257616e-07
```

## umap_demo

Typical output of the cells processing umap looks like:

- For blobs clustering test:
```
CPU times: user 15.4 s, sys: 1.71 s, total: 17.1 s
Wall time: 4.53 s
```

Final cell of blobs clustering test should output:

```
Cluster demonstration completed successfully
```


- For trustworthiness evaluation using random initialization:
```
CPU times: user 9.84 s, sys: 380 ms, total: 10.2 s
Wall time: 945 ms
```

Final cell of trustworthiness evaluation with random initialization should output:

```
Trustworthiness on random initialization passed successfully
```

- For trustworthiness evaluation using spectral initialization:

```
CPU times: user 9.83 s, sys: 296 ms, total: 10.1 s
Wall time: 832 ms
```

Final cell of trustworthiness evaluation with spectral initialization should output:

```
Trustworthiness on spectral initialization passed successfully
```

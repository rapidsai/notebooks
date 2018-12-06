# cuML Notebooks

## Summary

* `dbscan_demo`: Notebook showcasing density-based spatial clustering of applications with noise (dbscan) algorithm comparison between cuML and scikit-learn.
* `knn_demo`: Notebook showcasing k-nearest neighbors (knn) algorithm comparison between cuML and scikit-learn.
* `pca_demo`: Notebook showcasing principal component analysis (PCA) algorithm comparison between cuML and scikit-learn.
* `dask-setup.sh`: Notebook showcasing truncated singular value decomposition (tsvd) algorithm comparison between cuML and scikit-learn.

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

The knn_demo notebook showcases the connection that cuML provides between `cuDF` and `faiss-gpu`. Currently, it is supported to run without any additional steps for CUDA 9.2, but it requires building `faiss-gpu` from source for CUDA 10.0 with [GPU support](https://github.com/facebookresearch/faiss/blob/master/INSTALL.md).

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

Note that the indexes can differ currently between cuML and scikit-learn.

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


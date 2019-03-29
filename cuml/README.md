# cuML Notebooks

## Summary

* `dbscan_demo`: notebook showcasing density-based spatial clustering of applications with noise (dbscan) algorithm comparison between cuML and scikit-learn.
* `knn_demo`: notebook showcasing k-nearest neighbors (knn) algorithm comparison between cuML and scikit-learn.
* `pca_demo`: notebook showcasing principal component analysis (PCA) algorithm comparison between cuML and scikit-learn.
* `tsvd_demo`: notebook showcasing truncated singular value decomposition (tsvd) algorithm comparison between cuML and scikit-learn.
* `linear_regression`: notebook showcasing linear regression comparison between cuML and scikit-learn.
* `ridge_regression`: notebook showcasing ridge regression comparison between cuML and scikit-learn.
* `sgd`: notebook showcasing stochastic gradient descent comparison between cuML and scikit-learn.
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

Fit:

```
CPU times: user 1min 8s, sys: 21.2 s, total: 1min 30s
Wall time: 6.06 s
```

Predict:

```
CPU times: user 5.46 s, sys: 312 ms, total: 5.77 s
Wall time: 471 ms
```


- For cuML:

Fit:

```
CPU times: user 504 ms, sys: 347 ms, total: 851 ms
Wall time: 1.08 s
```

Predict:

```
CPU times: user 144 ms, sys: 7.71 ms, total: 152 ms
Wall time: 145 ms
```


Final cell of the notebook should output:

```
SKL MSE(y):
5.6481553e-05
CUML MSE(y):
7.246567e-07
```

## ridge_regression_demo

Typical output of the cells processing ridge_regression looks like:

- For scikit-learn:

Fit:

```
CPU times: user 1min 1s, sys: 1.99 s, total: 1min 3s
Wall time: 5.02 s
```

Predict:

```
CPU times: user 2.66 s, sys: 75.6 ms, total: 2.74 s
Wall time: 180 ms
```


- For cuML:

Fit:

```
CPU times: user 518 ms, sys: 309 ms, total: 827 ms
Wall time: 831 ms
```

Predict:

```
CPU times: user 146 ms, sys: 7.31 ms, total: 154 ms
Wall time: 149 ms
```

Final cell of the notebook should output:

```
SKL MSE(y):
0.0204307456949534
CUML MSE(y):
0.00012496959
```

## sgd_demo

Typical output of the cells processing sgd looks like:

- For scikit-learn:

Fit:

```
CPU times: user 10min 22s, sys: 417 ms, total: 10min 22s
Wall time: 10min 20s
```

Prefict:

```
CPU times: user 146 ms, sys: 63 ms, total: 209 ms
Wall time: 166 ms
```


- For cuML:

Fit:

```
CPU times: user 2min 13s, sys: 8.1 s, total: 2min 21s
Wall time: 2min 18s
```

Prefict:

```
CPU times: user 139 ms, sys: 10.9 ms, total: 150 ms
Wall time: 142 ms
```

Final cell of the notebook should output:

```
SKL MSE(y):
1.144686926876654e-07
CUML MSE(y):
1.0390148e-07
```

## umap_demo

This notebook currently performs assertions and does not print any output. It contains two types of tests that evaluate UMAP's ability to preserve local neighborhood structure.

The first test verifies that when the input contains blobs generated from several different clusters, the UMAP output produces low-dimensional blobs with the same number of clusters.

The second test demonstrates that the neighborhoods of the low-dimensional embeddings are similar to the neighborhoods of the inputs. A score, known as trustworthiness, and made popular by t-SNE, is used to evaluate the UMAP embeddings for both random and spectral initialization strategies.

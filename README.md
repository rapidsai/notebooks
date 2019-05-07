# RAPIDS Notebooks and Utilities

* `cuml`: contains several example notebooks showcasing the usage and advantages of using the different machine learning algorithms implemented in cuML over their standard implementations. The cuml folder contains notebooks on the following algorithms: `knn`, `dbscan`, `pca`, `tsvd`, `linear_regression`, `ridge_regression`, `sgd`, and `umap`. These notebooks compare the time required and their performance with the scikit-learn implementations. It also includes a small subset of the Mortgage Dataset and randomly generated datasets used to perform the analysis.

* `mortgage`: contains the notebook which runs ETL + ML on the Mortgage Dataset derived from [Fannie Mae’s Single-Family Loan Performance Data](http://www.fanniemae.com/portal/funding-the-market/data/loan-performance-data.html) ... download the mortgage dataset for use with the notebook [here](https://docs.rapids.ai/datasets/mortgage-data)

* `utils`: contains a set of useful scripts for interacting with RAPIDS

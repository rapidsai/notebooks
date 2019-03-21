

# cuGraph Notebooks

![GraphAnalyticsFigure](img/GraphAnalyticsFigure.jpg)

This repository contains a collection of Juyper Notebooks that outline how to run various cuGraph analytics.   The notebooks do not address a complete data science problem.  The notebooks are simply examples of how to run the graph analytics.  Manipulation of the data before or after the graph analytic is not covered here.   Extended, more problem focused, notebooks are being created and available https://github.com/rapidsai/notebooks-extended



## Notebook Types

Example code is broken into two subfolders

- SG - for Single GPU example
- _MG - for Multi-GPU examples using DASK- **notebooks coming soon in v0.7**_



## Notebooks

SG

- BFS Example 
- Jaccard Similarity
- Weighted Jaccard
- Louvain Example
- Page Rank
- Spectral Clustering - Balanced Cut
- Spectral Clustering - Modularity
- Single Source Shortest Path





## Requirements

Running the example in these notebooks requires:

* The latest version of RAPIDS with cuGraph.
  * Download via Docker, Conda, or PIP  
* cuGraph is dependent on the latest version of cuDF.  Please install all components of RAPIDS 
* Python 3.6+
* A system with an NVIDIA GPU:  Pascal architecture or better
* CUDA 9.2+
* NVIDIA driver 396.44+



#### Notebook Credits

- Original Authors: Bradley Rees and James Wyles
- Last Edit: 03/08/2019

RAPIDS Versions: 0.6.0    

Test Hardware

- GV100 32G, CUDA 9,2



##### Copyright

Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");  you may not use this file except in compliance with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.





![RAPIDS](img/rapids_logo.png)


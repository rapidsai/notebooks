#!/bin/bash

set -eu

echo "PLEASE READ"
echo "********************************************************************************************************"
echo "Colab v0.11+ Migration Notice:"
echo " "
echo "There has been a NECESSARY Colab script code change for VERSION 0.11+ that MAY REQUIRE an update how you install RAPIDS into Colab!  "
echo "Not all Colab notebooks are updated (like personal Colabs) and while the script will install RAPIDS correctly, "
echo "a neccessary script to update pyarrow to v0.15.x to be compatible with RAPIDS v0.11+ may not run, and your RAPIDS instance"
echo "will BREAK"
echo " "
echo "Please enter in the box your desired RAPIDS version (ex: '0.10' or '0.11', between 0.9 to 0.11, without the quotes) and hit Enter. "
read RAPIDS_VERSION
MULT="100"

#conditions accidental inputs
RAPIDS_RESULT=$(awk '{print $1*$2}' <<<"${RAPIDS_VERSION} ${MULT}")
#echo $RAPIDS_RESULT
if (( $RAPIDS_RESULT >=11 )) ;then
  RAPIDS_VERSION="0.11"
  RAPIDS_RESULT=11
  # echo "RAPIDS Version modified to 0.12 nightlies"
  echo "RAPIDS Version modified to 0.11 stable"
elif (( $RAPIDS_RESULT <= 9 )) ;then
  RAPIDS_VERSION="0.9"
  RAPIDS_RESULT=9
  echo "RAPIDS Version modified to 0.9 stable"
fi
#echo $RAPIDS_VERSION
if (( $RAPIDS_RESULT >= 11 )) ;then
  echo "Please COMPARE the \"SCRIPT TO COPY\" with the code in the above cell.  If they are the same, just type any key.  If not, do steps 2-4. "
  echo " "
  echo "SCRIPT TO COPY: "
  echo "!wget -nc https://raw.githubusercontent.com/rapidsai/notebooks-contrib/master/utils/rapids-colab.sh"
  echo "!bash rapids-colab.sh"
  echo "import sys, os"
  echo "dist_package_index = sys.path.index\('/usr/local/lib/python3.6/dist-packages'\)"
  echo "sys.path = sys.path[:dist_package_index] + ['/usr/local/lib/python3.6/site-packages'] + sys.path[dist_package_index:]"
  echo "sys.path"
  echo "if os.path.exists\('update_pyarrow.py'\): ## Only exists if RAPIDS version is 0.11 or higher"
  echo "  exec\(open\('update_pyarrow.py'\).read\(\), globals\(\)\)"
  echo "********************************************************************************************************"
  echo "Do you have the above version of the script running in your cell? (Y/N)"
  read response
  if [ $response == "Y" ] || [ $response == "y" ] ;then
    echo "Continuing with RAPIDS install"
  else
    echo "Please do the following:"
    echo "1. STOP cell execution" 
    echo "2. CUT and PASTE the script below into the cell you just ran "
    echo "3. RERUN the cell"
    echo " "
    echo "SCRIPT TO COPY:"
    echo "!wget -nc https://raw.githubusercontent.com/rapidsai/notebooks-contrib/master/utils/rapids-colab.sh"
    echo "!bash rapids-colab.sh"
    echo "import sys, os"
    echo "dist_package_index = sys.path.index\('/usr/local/lib/python3.6/dist-packages'\)"
    echo "sys.path = sys.path[:dist_package_index] + ['/usr/local/lib/python3.6/site-packages'] + sys.path[dist_package_index:]"
    echo "sys.path"
    echo "if os.path.exists\('update_pyarrow.py'\): ## Only exists if RAPIDS version is 0.11 or higher"
    echo "  exec\(open\('update_pyarrow.py'\).read\(\), globals\(\)\)"
    echo "********************************************************************************************************"
    rm rc2.sh
    echo "Please COPY the above code and RERUN the cell"
    exit 0
  fi
else
  echo "You may not have to change anything.  All versions of our script should work with this version of Colab"
fi

wget -nc https://github.com/rapidsai/notebooks-contrib/raw/master/utils/env-check.py
echo "Checking for GPU type:"
python env-check.py

if [ ! -f Miniconda3-4.5.4-Linux-x86_64.sh ]; then
    echo "Removing conflicting packages, will replace with RAPIDS compatible versions"
    # remove existing xgboost and dask installs
    pip uninstall -y xgboost dask distributed

    # intall miniconda
    echo "Installing conda"
    wget https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh
    chmod +x Miniconda3-4.5.4-Linux-x86_64.sh
    bash ./Miniconda3-4.5.4-Linux-x86_64.sh -b -f -p /usr/local
    
    if (( $RAPIDS_RESULT == 12 )) ;then #Newest nightly packages.  UPDATE EACH RELEASE!
    echo "Installing RAPIDS $RAPIDS_VERSION packages from the nightly release channel"
    echo "Please standby, this will take a few minutes..."
    # install RAPIDS packages
        conda install -y --prefix /usr/local \
                -c rapidsai-nightly/label/xgboost -c rapidsai-nightly -c nvidia -c conda-forge \
                python=3.6 cudatoolkit=10.0 \
                cudf=$RAPIDS_VERSION cuml cugraph gcsfs pynvml cuspatial xgboost\
                dask-cudf
        # check to make sure that pyarrow is running the right version (0.15) for v0.11 or later
        wget -nc https://github.com/rapidsai/notebooks-contrib/raw/master/utils/update_pyarrow.py
    elif (( $RAPIDS_RESULT >= 11 )) ;then #Stable packages requiring PyArrow 0.15
        echo "Installing RAPIDS $RAPIDS_VERSION packages from the stable release channel"
        echo "Please standby, this will take a few minutes..."
        # install RAPIDS packages
        conda install -y --prefix /usr/local \
            -c rapidsai/label/xgboost -c rapidsai -c nvidia -c conda-forge \
            python=3.6 cudatoolkit=10.0 \
            cudf=$RAPIDS_VERSION cuml cugraph cuspatial gcsfs pynvml xgboost\
            dask-cudf
        # check to make sure that pyarrow is running the right version (0.15) for v0.11 or later
        wget -nc https://github.com/rapidsai/notebooks-contrib/raw/master/utils/update_pyarrow.py
    else
        echo "Installing RAPIDS $RAPIDS_VERSION packages from the stable release channel"
        echo "Please standby, this will take a few minutes..."
        # install RAPIDS packages
        conda install -y --prefix /usr/local \
            -c rapidsai/label/xgboost -c rapidsai -c nvidia -c conda-forge \
            python=3.6 cudatoolkit=10.0 \
            cudf=$RAPIDS_VERSION cuml cugraph cuspatial gcsfs pynvml xgboost\
            dask-cudf
    fi
      
    echo "Copying shared object files to /usr/lib"
    # copy .so files to /usr/lib, where Colab's Python looks for libs
    cp /usr/local/lib/libcudf.so /usr/lib/libcudf.so
    cp /usr/local/lib/librmm.so /usr/lib/librmm.so
    cp /usr/local/lib/libnccl.so /usr/lib/libnccl.so
fi

echo ""
echo "*********************************************"
echo "Your Google Colab instance is RAPIDS ready!"
echo "*********************************************"

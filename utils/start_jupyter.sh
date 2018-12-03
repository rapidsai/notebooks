#!/bin/bash
nohup jupyter-lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token='' > /dev/null 2>&1 &
echo -e "\n"
echo "nohup jupyter-lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token='rapids' > /dev/null 2>&1 &"
echo -e "\n"

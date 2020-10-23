#!/bin/bash

git pull
git submodule update --init --remote --no-single-branch --depth 1

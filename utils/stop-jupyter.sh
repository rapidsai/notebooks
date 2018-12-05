#!/bin/bash
ps aux | grep jupyter | \
    grep --extended-regexp "$USER[\ ]{1,10}[0-9]{1,10}" | \
    grep --only-matching --extended-regexp "$USER[\ ]{1,10}[0-9]{1,10}" | \
    grep --only-matching --extended-regexp "[\ ]{1,10}[0-9]{1,10}" | \
    xargs kill -9
sleep 2
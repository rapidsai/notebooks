#!/bin/bash
set -e

SRC="/raid/mortgage/perf_clean"
DST="/raid/mortgage/perf_test"
WORK="/raid/mortgage/"

if [ $# -ne 1 ]; then
    echo "Must supply size"
    exit 1
fi

SIZE=$1

function logger() {
  TS=`date`
  echo "[$TS] $@"
}

function spill() {
    left=$1
    right=$2
    logger "  Checking for spill..."
    LAST=`tail -n1 $left | tr '|' ' ' | awk '{ print $1 }'`
    HEAD=`head -n1 $right | tr '|' ' ' | awk '{ print $1 }'`
    if [ "$LAST" == "$HEAD" ] ; then
        logger "    >>Spill detected, correcting<<"
        grep "$LAST" $right >> $left
        grep -v "$LAST" $right > "${right}_nospill"
        mv "${right}_nospill" $right
    else
        logger "    No spill"
    fi
}

for i in `ls $SRC` ; do
  logger "Processing $i"
  logger "  Sorting..."
  sort $SRC/$i > "$WORK/$i"
  logger "  Splitting..."
  files=$(split --verbose --line-bytes=$SIZE -d "$WORK/$i" | awk -F"'" '{print $2}')
  count=`echo $files | awk '{print NF}'`
  logger "  Split into $count files"
  rm -f "$WORK/$i"
  s=${#count}
  c=0
  for file in $files ; do
    printf -v pad "%0${s}d" $c
    mv $file $DST/${i}_$pad
    c=$(($c+1))
  done
  count=$(($count - 1))
  #spill $DST/${i}_0 $DST/${i}_1
  for (( c=0; c<$count; c++)) do
    printf -v lpad "%0${s}d" $c
    printf -v rpad "%0${s}d" $(($c+1))
    left="$DST/${i}_$lpad"
    right="$DST/${i}_$rpad"
    spill $left $right
  done
done


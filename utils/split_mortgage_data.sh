#!/bin/bash
set -e
#Usage: ./split_mortgage_data.sh 500M
#Adjust size as needed

SRC="/raid/mortgage/perf_clean"
DST="/raid/mortgage/perf_test"

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
  sort $SRC/$i > /tmp/$i
  logger "  Splitting..."
  split -C $SIZE -d /tmp/$i
  count=$(split --verbose --line-bytes=$SIZE -d /tmp/$i | wc -l)
  logger "  Split into $count files"
  rm -f /tmp/$i
  for (( c=0; c<$count; c++)) do
    printf -v pad "%02d" $c
    mv x$pad $DST/${i}_$pad
  done
  count=$(($count - 1))
  #spill $DST/${i}_0 $DST/${i}_1
  for (( c=0; c<$count; c++)) do
    printf -v lpad "%02d" $c
    printf -v rpad "%02d" $(($c+1))
    left="$DST/${i}_$lpad"
    right="$DST/${i}_$rpad"
    spill $left $right
  done
done


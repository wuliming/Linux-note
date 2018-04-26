#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

. ./common.sh

MODE=$1
tazyu=$2
filesystem=$3
agent=$4
size=$5
bs=$6
DATE=`date +%m%d%H%M%S`
RESULT_DIR="result/$filesystem-$MODE-$size-$bs/round-$agent/$tazyu-tazyu"
GETDATA_DIR="test_out/$filesystem-$MODE-$tazyu-$size-$bs"
mkdir -p $RESULT_DIR
mkdir -p $GETDATA_DIR

echo "---start of MODE $MODE, tazyu $tazyu---"

if (( $tazyu <= 4 ))
then
   for i in `seq 1 $tazyu`
   do
     ((tmp=$i-1))
     cat $RESULT_DIR/fio-${DISK[$tmp]}-1.txt | grep iops | awk -F ',' '{ print $3 }' | awk -F '=' '{ print $2 }' >> $GETDATA_DIR/fio-${DISK[$tmp]}-1.csv
     if (( $agent == $TESTTIMES ))
     then
       cat $GETDATA_DIR/fio-${DISK[$tmp]}-1.csv | awk '{ sum += $1; } END { print sum/NR}' > $GETDATA_DIR/aver-fio-${DISK[$tmp]}-1.csv
       cat $GETDATA_DIR/aver-fio-${DISK[$tmp]}-1.csv >> $GETDATA_DIR/tmpsum-$tazyu.csv
       rm -rf $GETDATA_DIR/fio-${DISK[$tmp]}-1.csv
       rm -rf $GETDATA_DIR/aver-fio-${DISK[$tmp]}-1.csv
     fi
   done
    if (( $agent == $TESTTIMES ))
     then
     cat $GETDATA_DIR/tmpsum-$tazyu.csv | awk '{ sum += $1; } END { print sum}' > $GETDATA_DIR/sum-tazyu$tazyu.csv
     echo "----------------tazyu $tazyu mode $MODE bs $bs size $size filesystem $filesystem---------------------" >> fio-result.csv
     cat $GETDATA_DIR/tmpsum-$tazyu.csv | awk '{ sum += $1; } END { print sum}' >> fio-result.csv
     rm -rf $GETDATA_DIR/tmpsum-$tazyu.csv
    fi
fi


if (( $tazyu > 4 ))
then
  ((mtazyu=$tazyu/${#DISK[@]}))
  j=0
  for disk in ${DISK[@]}
  do
    ((tmp=$j*$mtazyu))
    for i in `seq 1 $mtazyu`
    do
       cat $RESULT_DIR/fio-${disk}-$i.txt | grep iops | awk -F ',' '{ print $3 }' | awk -F '=' '{ print $2 }'  >> $GETDATA_DIR/fio-${disk}-$i.csv
       if (( $agent == $TESTTIMES ))
       then
         cat $GETDATA_DIR/fio-${disk}-$i.csv | awk '{ sum += $1; } END { print sum/NR}' > $GETDATA_DIR/aver-fio-${disk}-$i.csv
         cat $GETDATA_DIR/aver-fio-${disk}-$i.csv >> $GETDATA_DIR/tmpsum-$tazyu.csv
         rm -rf $GETDATA_DIR/fio-${disk}-$i.csv
         rm -rf $GETDATA_DIR/aver-fio-${disk}-$i.csv
       fi 
       ((tmp++))
        echo $tmp
    done
    ((j++))
  done
    if (( $agent == $TESTTIMES ))
    then
      cat $GETDATA_DIR/tmpsum-$tazyu.csv | awk '{ sum += $1; } END { print sum}' > $GETDATA_DIR/sum-tazyu$tazyu.csv
      echo "----------------tazyu $tazyu mode $MODE bs $bs size $size filesystem $filesystem----------------------" >> fio-result.csv
      cat $GETDATA_DIR/tmpsum-$tazyu.csv | awk '{ sum += $1; } END { print sum}' >> fio-result.csv
      rm -rf $GETDATA_DIR/tmpsum-$tazyu.csv
    fi
fi


wait

echo "---end of MODE $MODE, tazyu $tazyu---"


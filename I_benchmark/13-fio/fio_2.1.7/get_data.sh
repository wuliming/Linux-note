#!/bin/bash
file=$1
MODE=`ls $file/`
for mode in $MODE
do
echo "******mode=$mode result******"
cat $file/$mode/round-*/log_fio.log | grep iops
echo -n "AVG iops : " 
cat $file/$mode/round-*/log_fio.log | grep iops | awk 'BEGIN{FS=","}{print $3}' | awk 'BEGIN{FS="=";sum=0;num=0}{sum=sum+$2;num++}END{print sum/num}'
done

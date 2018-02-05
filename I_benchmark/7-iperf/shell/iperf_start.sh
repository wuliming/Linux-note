#!/bin/sh

#Program:
#	Get system's performance info
#History:
#	yuyuan 2016/7/8 0.1v

export LANG=C

PORT=$1
BIND_CPU=$2 
iperf3 -s -p $PORT &
PID=$!
if [ $BIND_CPU -eq 1 ];then
	CPU=`cat /proc/cpuinfo | grep processor | wc -l`
	CPU=`expr $CPU - 1`
	taskset -cp $CPU $PID
fi

echo "iperf3 -s -p $PORT "


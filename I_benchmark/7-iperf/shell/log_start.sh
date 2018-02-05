#!/bin/sh

#Program:
#	Get system's performance info
#History:
#	renyl 2014/7/10 0.1v

export LANG=C

#HOST_IP="192.168.100.10"
#HOST_DIR="/home/yuyuan/iperf"
if [ "$#" != 1 ];then 

	echo "Parameter is wrong."
	echo "Usage: $0  <LOG_DIR>"
	echo "Example: $0  ./log"
	echo "Waring: "LOG_DIR" need relative or absolute PATH."
	exit 1
fi


LOG_DIR=$1

if [ ! -d ${LOG_DIR} ];then
	
	if [ -f ${LOG_DIR} ];then
	
		echo "${LOG_DIR} is a regular file."
		echo "Parameter should be  a directory."
		exit 1

	fi

	mkdir -p ${LOG_DIR}
fi

LOG_DIR=`echo ${LOG_DIR%/}`  
DATE=`date +%m%d%H%M%S`

#LOG_HOST="host/$DATE"
#ssh $HOST_IP "cd $HOST_DIR; mkdir -p $LOG_HOST; ./log_start.sh $LOG_HOST" &
getPerfInfo.sh -d  ${LOG_DIR}/${DATE}/"getperfinfo" 2 30000 &
sleep 2
./get_ethtool.sh ${LOG_DIR} &
./get_netinfo.sh ${LOG_DIR} &

./get_proc_net.sh $LOG_DIR

echo "It have started up gerPerfInfo process to collect system info."


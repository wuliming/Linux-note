#!/bin/bash

#Program:
#	Stop all getPerfInfo  process
#History:
#	renyl 2014/7/11 0.1v


export LANG=c
#HOST_IP="192.168.100.10"
#HOST_DIR="/home/yuyuan/iperf"
PIDS=`ps aux | grep getPerfInfo.sh  | grep -v "grep" | awk '{print $2}'`


if [ "${PIDS}" == "" ];
then
	echo "Note: NO getPerfInfo  process  is  running."
else


echo "$PIDS" | while read PID
do

	getPerfInfo.sh --kill $PID

done

fi

PIDS_1=`ps aux | grep get_ethtool.sh  | grep -v "grep" | awk '{print $2}'`



echo "$PIDS_1" | while read PID
do

        kill  -9 $PID

done


PIDS_2=`ps aux | grep get_netinfo.sh  | grep -v "grep" | awk '{print $2}'`


echo "$PIDS_2" | while read PID
do

        kill  -9 $PID

done

pkill get_proc_net.sh

#ssh  $HOST_IP "cd $HOST_DIR; ./log_stop.sh;"
echo "It have killed all getPerfInfo  process."
echo "It have killed all get_ethtool.sh  process."




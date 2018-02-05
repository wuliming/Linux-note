#!/bin/bash


export LANG=c

PIDS=`ps aux | grep "iperf3 -s"  | grep -v "grep" | awk '{print $2}'`


if [ "${PIDS}" == "" ];
then
	echo "Note: NO iperf  process  is  running."
	exit 1
fi

echo "$PIDS" | while read PID
do

 kill  -9 $PID

done


echo "It have killed all iperf process."



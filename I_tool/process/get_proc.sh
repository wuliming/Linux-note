#!/bin/sh
if [[ "$1" == "--stop" ]]; then
	pkill -9 get_proc.sh
	sleep 3
	exit 0
else
	GREP=$1
fi

INTERVAL=$2

if [[ "$3" == "" ]]; then
	COUNT=100000
else
	COUNT=$3
fi

for (( i=0; i<${COUNT}; i++ ))
do
	date +"%D %T %s"
	ps -eo "time,pid,ppid,%cpu,%mem,psr,pcpu,stat,wchan:14,time,comm,args" |grep ${GREP}
	sleep ${INTERVAL}
done

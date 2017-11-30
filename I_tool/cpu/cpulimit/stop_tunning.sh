#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

killall while1
killall cpulimit

for i in `seq 1 2`
do
	CPULIMIT_PIDS=`ps aux | grep "cpulimit" | awk '{print $2}' | sed '$d'`
	WHILE1_PIDS=`ps aux | grep "while1" | awk '{print $2}' | sed '$d'`
	
	for each_pid in $CPULIMIT_PIDS
	do
		kill -9 ${each_pid}
	done

	for each_pid in $WHILE1_PIDS
	do
		kill -9 ${each_pid}
	done
done
echo "TUNNING STOPPED"

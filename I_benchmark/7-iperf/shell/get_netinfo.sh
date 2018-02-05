#!/bin/sh

export LANG=C

DATE=`date +%m%d%H%M%S`
TEMPDIR=$1

while true
do
       	ifconfig  >> "$TEMPDIR/ifconfig_$DATE" 2>&1
	
        netstat -s >> "$TEMPDIR/nestat-s_$DATE" 2>&1
	sleep 2 
done


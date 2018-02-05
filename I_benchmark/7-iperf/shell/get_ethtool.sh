#!/bin/sh

export LANG=C

NET_DEV=`ifconfig -a | grep ens | awk '{print $1}'`
DATE=`date +%m%d%H%M%S`
TEMPDIR=$1

while true
do
	for IFACE in $NET_DEV
	do
	        echo "$IFACE"      >> "$TEMPDIR/ethtool-S_$DATE"
        	ethtool -S $IFACE  >> "$TEMPDIR/ethtool-S_$DATE" 2>&1
	        echo ""            >> "$TEMPDIR/ethtool-S_$DATE"
	
       		echo "$IFACE"      >> "$TEMPDIR/ethtool-k_$DATE"
	        ethtool -k $IFACE  >> "$TEMPDIR/ethtool-k_$DATE" 2>&1
        	echo ""            >> "$TEMPDIR/ethtool-k_$DATE"
	done
	sleep 2 
done


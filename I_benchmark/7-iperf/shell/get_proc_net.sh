#!/bin/bash

dir=$1
cd $dir
watch_file() {
    while :; do
        date +'%s.%N'
        cat $1
        echo
        sleep 1
    done

}
watch_file /proc/net/dev > procfs_net_dev.log &
watch_file /proc/net/snmp > procfs_net_snmp.log &
watch_file /proc/net/softnet_stat > procfs_net_softnet_stat.log &

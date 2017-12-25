# !/bin/sh
INTERVAL=$1
GREP=$2
watch -d -n ${INTERVAL} "ps -eo time,pid,ppid,%cpu,%mem,psr,rss,vsz,size,comm,args | grep -v grep | grep ${GREP}"


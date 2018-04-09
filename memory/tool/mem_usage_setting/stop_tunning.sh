#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

killall mem_take

MEM_TAKE_PID=`ps aux | grep "mem_take" | awk '{print $2}' | sed '$d'`

kill -9 $MEM_TAKE_PID

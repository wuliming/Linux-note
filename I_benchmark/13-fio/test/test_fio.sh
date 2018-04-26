#!/bin/sh

set -x
fio fs_seq_write_sync_001 > seq_write_sync_001_$1.log 2>&1 &
pid=$!
sleep 0.5 
PID1=`pgrep -P ${pid} | head -1`
PID2=`pgrep -P ${pid} | tail -1`
strace -ttt -T -e trace=desc -C -o strace_seq_write_sync_001_$1.log -p $PID1 &
perf record -a -g --call-graph dwarf -F 997 -p $PID2 & 


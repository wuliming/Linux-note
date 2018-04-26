#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

#MODE="direct-64-seqread-1jobs direct-64-seqwrite-1jobs direct-8-randread-1jobs direct-8-randwrite-1jobs direct-64-seqread-2jobs direct-64-seqwrite-2jobs direct-8-randread-2jobs direct-8-randwrite-2jobs direct-64-seqread-6jobs direct-64-seqwrite-6jobs direct-8-randread-6jobs direct-8-randwrite-6jobs direct-64-seqread-10jobs direct-64-seqwrite-10jobs direct-8-randread-10jobs direct-8-randwrite-10jobs"
#MODE="buffer-64-seqread buffer-64-seqwrite buffer-8-seqread buffer-8-seqwrite buffer-8-randread buffer-8-randwrite direct-8-randread direct-8-randwrite"
MODE="direct-64-seqread-6jobs direct-64-seqwrite-6jobs direct-8-randread-6jobs direct-8-randwrite-6jobs direct-64-seqread-10jobs direct-64-seqwrite-10jobs direct-8-randread-10jobs direct-8-randwrite-10jobs"
ROUND=3
RESULT_DIR="./log"
PWD=`pwd`
TEST_DIR=$PWD





for((round=1;round<=ROUND;round++)) 
do
		
	for mode in $MODE
	do
		log="$RESULT_DIR/$mode/round-$round"
		mkdir -p $log
		#sync
		#echo 3 > /proc/sys/vm/drop_caches
		../tool/log_start.sh $log/getperfinfo &
		echo "mode=$mode round=$round"
                if [ "$mode" = "direct-8-randread-1jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-1jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-1jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=read -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-1jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=write -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randread-2jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-2jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-2jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=read -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-2jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=write -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randread-6jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-6jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-6jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=read -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-6jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=write -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randread-10jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-10jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-10jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=read -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-10jobs" ];then
                        fio -filename=/FIO/iotest/fiotest  -iodepth=1  -rw=write -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
		else
			echo "exit"	
		fi
		../tool/log_stop.sh
		
		sleep 1
	done
done






















#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

GUEST_IP="192.168.122.133"

MODE="direct-64-seqread-1jobs direct-64-seqwrite-1jobs direct-8-randread-1jobs direct-8-randwrite-1jobs direct-64-seqread-2jobs direct-64-seqwrite-2jobs direct-8-randread-2jobs direct-8-randwrite-2jobs direct-64-seqread-6jobs direct-64-seqwrite-6jobs direct-8-randread-6jobs direct-8-randwrite-6jobs direct-64-seqread-10jobs direct-64-seqwrite-10jobs direct-8-randread-10jobs direct-8-randwrite-10jobs"
#MODE="buffer-64-seqread buffer-64-seqwrite buffer-8-seqread buffer-8-seqwrite buffer-8-randread buffer-8-randwrite direct-8-randread direct-8-randwrite"
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
		ssh $GUEST_IP "libaio"
#		libaio
#		echo 3 > /proc/sys/vm/drop_caches
		../tool/log_start.sh $log/getperfinfo_host &
		ssh $GUEST_IP "cd $TEST_DIR; ../tool/log_start.sh getperfinfo_guest" &
		echo "mode=$mode round=$round"
                if [ "$mode" = "direct-8-randread-1jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-1jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-1jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqread -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-1jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqwrite -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=1 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                if [ "$mode" = "direct-8-randread-2jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-2jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-2jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqread -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-2jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqwrite -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=2 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                if [ "$mode" = "direct-8-randread-6jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-6jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-6jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqread -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-6jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqwrite -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=6 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                if [ "$mode" = "direct-8-randread-10jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randread -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-8-randwrite-10jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=randwrite -bs=8k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqread-10jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqread -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                elif [ "$mode" = "direct-64-seqwrite-10jobs" ];then
                        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest  -iodepth=1  -rw=seqwrite -bs=64k -ioengine=libaio -direct=1 -size=4GB --runtime=50 -numjobs=10 -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
                else
                        echo "exit"
                fi
			
		../tool/log_stop.sh
		ssh $GUEST_IP "cd $TEST_DIR; ../tool/log_stop.sh"
		scp -r $GUEST_IP:$TEST_DIR/getperfinfo_guest $log/
		ssh $GUEST_IP "cd $TEST_DIR; rm -rf getperfinfo_guest"
		
		sleep 1
	done
done






















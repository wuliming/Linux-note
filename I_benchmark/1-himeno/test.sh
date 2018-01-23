#!/bin/sh
#
# Program:
#       himeno test scripts
# History:
#       wulm 2017/11/28 1.0v
#

. ./common.sh
export LANG=c

PWD=`pwd`
for((i=1;i<=$TEST_TIMES;i++))
do
	DATE=`date +%m%d%H%M`
	if [ "$TEST_MODE" = 0 ];then
		TAZYU=$TAZYU_NATIVE
	else
		TAZYU=$TAZYU_GUEST
	fi
	for TAZYU_COUNT in $TAZYU
	do
		log="$LOG_DIR/${DATE}/${TAZYU_COUNT}-tazyu"
		mkdir -p $log
		if [ "$TEST_MODE" = 0 ];then
			echo "******** TEST_MODE=native TEST_TIME=$i TAZYU=$TAZYU_NATIVE BIND_CPU=$BIND_CPU CFLAGS=$CFLAGS ********"       
			./start_run.sh $TAZYU_COUNT $BIND_CPU $CFLAGS
			mkdir ${log}/getperfinfo_native
			mv getperfinfo* $log/getperfinfo_native
			mv himeno-* $log/ 	
		else
			echo "******** TEST_MODE=guest TEST_TIME=$i TAZYU=$TAZYU_GUEST BIND_CPU=$BIND_CPU CFLAGS=$CFLAGS ********"       
			GUEST_DIR=$PWD
			../tool/log_start.sh $log/getperfinfo_host
			ssh $GUEST_IP "cd $GUEST_DIR; ./start_run.sh $TAZYU_COUNT $BIND_CPU $CFLAGS"
			sleep 10
			../tool/log_stop.sh
			scp -r $GUEST_IP:$GUEST_DIR/getperfinfo $log/getperfinfo_guest
			scp -r $GUEST_IP:$GUEST_DIR/himeno-* $log/
			ssh $GUEST_IP "cd $GUEST_DIR; rm -rf $GUEST_DIR/getperfinfo;rm -rf $GUEST_DIR/himeno-*"
		fi
	done
	sleep 10
done
echo END_OF_HIMENO

#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

GUEST_IP="192.168.122.3"

ROUND=15
RESULT_DIR="./log"
PWD=`pwd`
TEST_DIR=$PWD
SIZE=4GB
IOENGINE=libaio
RUNTIME=50

ssh $GUEST_IP "df | grep /home/iotest | grep vdc > /dev/null"
if [ $? -ne 0 ]; then
  echo "/dev/vdc may not be mounted on /home/iotest"
  exit 1
fi

for depth in 8; do
  for num_jobs in 1; do
    for line in "64k write sync" "8k randwrite sync" "64k read -" "8k randread -"; do
      for round in `seq $ROUND` ; do
        array=($line)
        bs=${array[0]}
        rw=${array[1]}
        is_sync=${array[2]}
        mode=direct-${bs}-${rw}-${num_jobs}jobs-${depth}depth
        log="$RESULT_DIR/$mode/round-$round"
        mkdir -p $log

        ../tool/log_start.sh $log/getperfinfo_host &
        ssh $GUEST_IP "cd $TEST_DIR; ../tool/log_start.sh getperfinfo_guest" &
        /home/matsu/remote_log_start.sh

        echo "mode=$mode round=$round"
        if [ $is_sync == "sync" ]; then
          sync
          ssh 10.125.5.220 "sync"
          echo "sync done"
        fi

        sleep 3
        echo "start fio"
        echo "fio -filename=/home/iotest/fiotest -iodepth=$depth -rw=$rw -bs=$bs -ioengine=$IOENGINE -direct=1 -size=$SIZE --runtime=$RUNTIME -numjobs=$num_jobs -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
        ssh $GUEST_IP "fio -filename=/home/iotest/fiotest -iodepth=$depth -rw=$rw -bs=$bs -ioengine=$IOENGINE -direct=1 -size=$SIZE --runtime=$RUNTIME -numjobs=$num_jobs -directory=/home/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log

        ../tool/log_stop.sh
        ssh $GUEST_IP "cd $TEST_DIR; ../tool/log_stop.sh"
        scp -r $GUEST_IP:$TEST_DIR/getperfinfo_guest $log/
        ssh $GUEST_IP "cd $TEST_DIR; rm -rf getperfinfo_guest"
        /home/matsu/remote_log_stop.sh $log
		
        sleep 1

      done
    done
  done
done

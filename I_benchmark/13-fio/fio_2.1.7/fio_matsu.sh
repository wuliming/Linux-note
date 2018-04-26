
#!/bin/bash

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

ROUND=15
RESULT_DIR="./log"
PWD=`pwd`
TEST_DIR=$PWD
SIZE=4GB
IOENGINE=libaio
RUNTIME=50

for depth in 8; do
  for num_jobs in 3; do
    for line in "64k write sync" "8k randwrite sync" "64k read -" "8k randread -"; do
      for round in `seq $ROUND` ; do
        array=($line)
        bs=${array[0]}
        rw=${array[1]}
        is_sync=${array[2]}
        mode=direct-${bs}-${rw}-${num_jobs}jobs-${depth}depth
        log="$RESULT_DIR/$mode/round-$round"
        mkdir -p $log
        ../tool/log_start.sh $log/getperfinfo &
#        /home/matsu/remote_log_start.sh
        echo "mode=$mode round=$round"
        if [ $is_sync == "sync" ]; then
          ssh 192.168.20.121 "sync"
          echo "sync done"
        fi
        sleep 5
        echo "start fio"
        echo "fio -filename=/FIO/iotest/fiotest -iodepth=$depth -rw=$rw -bs=$bs -ioengine=$IOENGINE -direct=1 -size=$SIZE --runtime=$RUNTIME -numjobs=$num_jobs -directory=/FIO/iotest/ -group_reporting -name=myFioTest" >> $log/log_fio.log
        fio -filename=/FIO/iotest/fiotest -iodepth=$depth -rw=$rw -bs=$bs -ioengine=$IOENGINE -direct=1 -size=$SIZE --runtime=$RUNTIME -numjobs=$num_jobs -directory=/FIO/iotest/ -group_reporting -name=myFioTest >> $log/log_fio.log
	../tool/log_stop.sh
#        /home/matsu/remote_log_stop.sh $log
		
	sleep 5
      done
    done
  done
done


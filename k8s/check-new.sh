#!/bin/sh


# arg1=start, arg2=end, format: %s.%N
function getTiming() {
    start=$1
    end=$2
   
    start_s=$(echo $start | cut -d '.' -f 1)
    start_ns=$(echo $start | cut -d '.' -f 2)
    end_s=$(echo $end | cut -d '.' -f 1)
    end_ns=$(echo $end | cut -d '.' -f 2)

    time=$(( ( 10#$end_s - 10#$start_s ) * 1000 + ( 10#$end_ns / 1000000 - 10#$start_ns / 1000000 ) ))
    echo "$time ms"
}
echo 3 > /proc/sys/vm/drop_caches
sleep 5
./restart.sh

function restore() {
    newcount=100
    kubectl  scale --replicas=0 deploy/nginx-deployment 
    #kubectl  delete pod --all & 
    while [[ $newcount  > 1 ]]
    do
    #      newcount=` kubectl get pods  | wc -l `
           newcount=` kubectl get pods  | grep -v NAME | wc -l`
    done
}

restore
PODS_NUM="800 700"
#PODS_NUM="10 20 40 80 100 200 400"
for pods_num in $PODS_NUM
do
TIME=`date +%Y%m%d%H%M`
count=100
LOG_DIR="log_pod/${pods_num}"
mkdir -p $LOG_DIR
sar -u ALL -P ALL 1 -o $LOG_DIR/${pods_num}_container_${TIME}_sar >/dev/null 2>&1 &
top -b -d 3 > $LOG_DIR/${pods_num}_container_${TIME}_top.txt &
start=$(date +%s.%N)
kubectl  scale --replicas=${pods_num} deploy/nginx-deployment  
while [[ $count > 1 ]]
do
	count=`kubectl get pods | grep -v Running | wc -l`
#	sleep 0.5
done

end=$(date +%s.%N)
getTiming $start $end > $LOG_DIR/${pods_num}_container_${TIME}.log

pkill sar
pkill top

restore
done

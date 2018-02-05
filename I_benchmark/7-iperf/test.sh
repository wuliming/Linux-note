#!/bin/bash 

export LANG=C
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"


. ./common.sh
iptables -F
cd $TEST_DIR

echo "stopping or starting irqbalance.service "

if [ $IRQBALANCE -eq 0 ];then
	systemctl stop irqbalance.service
	if [ $GUEST_TEST -eq 1 ];then
		ssh $SERVER_IP "iptables -F;systemctl stop irqbalance.service"
	fi
	ssh $CLIENT_IP "iptables -F;systemctl stop irqbalance.service; "
else 
	systemctl start irqbalance.service
	if [ $GUEST_TEST -eq 1 ];then
		ssh $SERVER_IP "iptables -F;systemctl start irqbalance.service"
	fi
	ssh $CLIENT_IP "iptables -F;systemctl start irqbalance.service; "
fi



echo "install iperf"
if [ $GUEST_TEST -eq 1 ];then
	ssh $SERVER_IP "rpm -ivh $RPM_DIR/iperf3-3.0.11-1.fc22.x86_64.rpm"
else
	rpm -ivh $RPM_DIR/iperf3-3.0.11-1.fc22.x86_64.rpm
fi
ssh ${CLIENT_IP} "rpm -ivh $RPM_DIR/iperf3-3.0.11-1.fc22.x86_64.rpm "

echo "start iperf service in server machine"

cd $SHELL_DIR
if [ $GUEST_TEST -eq 1 ];then
	ssh $SERVER_IP "cd $SHELL_DIR; ./iperf_start.sh $PORT $BIND_CPU" &
else
	./iperf_start.sh $PORT $BIND_CPU
fi
sleep 2
# perf stat -e kvm:kvm_entry -e kvm:kvm_exit -p $qemu-kvm_PID
for lenth in $LENTH
do
	for round in `seq 1 $ROUND`
	do
		for tazyu in $TAZYU
		do
			echo "----------start of round=$round/$ROUND, ----------"
			LOG_CLIENT="$TEST_DIR/log-client/lenth-$lenth/round-$round/tazyu-$tazyu/"
			LOG_SERVER="$TEST_DIR/log-server/lenth-$lenth/round-$round/tazyu-$tazyu/"
			LOG_HOST="$TEST_DIR/log-host/lenth-$lenth/round-$round/tazyu-$tazyu/"
			
			if [ $GUEST_TEST -eq 1 ];then
				mkdir -p $LOG_HOST
				./log_start.sh $LOG_HOST
		                ssh $SERVER_IP  "iptables -F; cd $SHELL_DIR; mkdir -p $LOG_SERVER; ./log_start.sh $LOG_SERVER " &
			else
				mkdir -p $LOG_SERVER
				./log_start.sh $LOG_SERVER
			fi
			ssh $CLIENT_IP "iptables -F; cd $SHELL_DIR; mkdir -p $LOG_CLIENT; ./log_start.sh $LOG_CLIENT" &
			
			if [ $GUEST_TEST -eq 1 ];then
				ssh $CLIENT_IP "iperf3 -c $SERVER_IP -p $PORT  -B $CLIENT_IP -l $lenth -P $tazyu -i $INTERVAL -t $TIME" > ${LOG_HOST}/iperf_result.txt
			else
				ssh $CLIENT_IP "iperf3 -c $SERVER_IP -p $PORT  -B $CLIENT_IP -l $lenth -P $tazyu -i $INTERVAL -t $TIME" > ${LOG_SERVER}/iperf_result.txt
			fi

		        sleep 10

			ssh $CLIENT_IP "cd $SHELL_DIR; ./log_stop.sh"
		        if [ $GUEST_TEST == "1" ];then
        	        	ssh $SERVER_IP  "cd $SHELL_DIR; ./log_stop.sh"
        		fi
			./log_stop.sh
			sleep 10
		done
	done
	echo "----------end of round=$round/$ROUND, ----------"	
done

echo "stop iperf3"
if [ $GUEST_TEST == "1" ];then
	ssh $SERVER_IP "cd $SHELL_DIR;./iperf_stop.sh"
else
	./iperf_stop.sh
fi
cd $TEST_DIR

echo "copy test log"
DATE=`date +%m%d%H%M%S`
mkdir -p $LOG_DIR/$DATE
scp -r ${CLIENT_IP}:$TEST_DIR/log-client  $LOG_DIR/$DATE/
ssh ${CLIENT_IP} "rm -rf $TEST_DIR/log-client "

if [ $GUEST_TEST == "1" ];then
        scp -r ${SERVER_IP}:$TEST_DIR/log-server  $LOG_DIR/$DATE/
        ssh $SERVER_IP  "rm -rf $TEST_DIR/log-server "
	mv $TEST_DIR/log-host $LOG_DIR/$DATE/log-host 
else
	mv $TEST_DIR/log-server $LOG_DIR/$DATE/log-server
fi
	

echo "END_IPERF_TEST"


#!/bin/sh

export LANG=C

DATE=`date +%m%d%H%M%S`

. ./common.sh

echo "get iperf result"

echo "SENDER"
for lenth in $LENTH
do
	echo lenth-$lenth
        for tazyu in $TAZYU
	do
		count=0
		SENDER_SUM=0
                for round in `seq 1 $ROUND`
                do
                        LOG_CLIENT="$LOG_DIR/*/log-client/lenth-$lenth/round-$round/tazyu-$tazyu"
			
			#echo LENTH-$lenth:TAZYU-$tazyu:round-$round
			if [ $tazyu == "1" ];then
				SENDER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep sender | awk '{print $7}' `
				SENDER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep sender | awk '{print $8}' `
				 RECEIVER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | awk '{print $7}' `
				 RECEIVER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | awk '{print $8}' `

			else
                        	SENDER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep sender | grep SUM | awk '{print $6}' `
                        	SENDER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep sender | grep SUM | awk '{print $7}' `
                        	RECEIVER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $6}' `
                        	RECEIVER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $7}' `
			fi
			let count+=1
			let SENDER_SUM+=$SENDER
			
		done
		let SENDER_SUM=${SENDER_SUM}/$count
		echo $SENDER_SUM
        done
done

echo "RECEIVER"
for lenth in $LENTH
do
	echo lenth-$lenth
        for tazyu in $TAZYU
        do
                count=0
                RECEIVER_SUM=0
                for round in `seq 1 $ROUND`
                do
                        LOG_CLIENT="$LOG_DIR/*/log-client/lenth-$lenth/round-$round/tazyu-$tazyu"

                        #echo LENTH-$lenth:TAZYU-$tazyu:round-$round
                        if [ $tazyu == "1" ];then
                                 RECEIVER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | awk '{print $7}' `
                                 RECEIVER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | awk '{print $8}' `

                        else
                                RECEIVER=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $6}' `
                                RECEIVER_UNIT=`cat  ${LOG_CLIENT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $7}' `
                        fi
                        let count+=1
                        let RECEIVER_SUM+=$RECEIVER

                done
                let RECEIVER_SUM=${RECEIVER_SUM}/$count
                echo $RECEIVER_SUM
        done
done

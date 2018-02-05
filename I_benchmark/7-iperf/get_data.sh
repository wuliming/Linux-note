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
			if [ $GUEST_TEST -eq 0 ];then
				LOG_RESULT="$LOG_DIR/*/log-server/lenth-$lenth/round-$round/tazyu-$tazyu"
			else
				LOG_RESULT="$LOG_DIR/*/log-host/lenth-$lenth/round-$round/tazyu-$tazyu"
			fi
			
			#echo LENTH-$lenth:TAZYU-$tazyu:round-$round
			if [ $tazyu == "1" ];then
				SENDER=`cat  ${LOG_RESULT}/iperf_result.txt | grep sender | awk '{print $7}' `
				SENDER_UNIT=`cat  ${LOG_RESULT}/iperf_result.txt | grep sender | awk '{print $8}' `

			else
                        	SENDER=`cat  ${LOG_RESULT}/iperf_result.txt | grep sender | grep SUM | awk '{print $6}' `
                        	SENDER_UNIT=`cat  ${LOG_RESULT}/iperf_result.txt | grep sender | grep SUM | awk '{print $7}' `
			fi
			count=`expr $count + 1`
			SENDER_SUM=`echo "$SENDER_SUM $SENDER" | awk '{print $1+$2}'`
			
		done
		SENDER_SUM=`echo "$SENDER_SUM $count" | awk '{print $1/$2}' `
		echo "$SENDER_SUM $SENDER_UNIT"
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
			if [ $GUEST_TEST -eq 0 ];then
				LOG_RESULT="$LOG_DIR/*/log-server/lenth-$lenth/round-$round/tazyu-$tazyu"
			else
				LOG_RESULT="$LOG_DIR/*/log-host/lenth-$lenth/round-$round/tazyu-$tazyu"
			fi

                        #echo LENTH-$lenth:TAZYU-$tazyu:round-$round
                        if [ $tazyu == "1" ];then
                                 RECEIVER=`cat  ${LOG_RESULT}/iperf_result.txt | grep receiver | awk '{print $7}' `
                                 RECEIVER_UNIT=`cat  ${LOG_RESULT}/iperf_result.txt | grep receiver | awk '{print $8}' `

                        else
                                RECEIVER=`cat  ${LOG_RESULT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $6}' `
                                RECEIVER_UNIT=`cat  ${LOG_RESULT}/iperf_result.txt | grep receiver | grep SUM | awk '{print $7}' `
                        fi
			count=`expr $count + 1`
			RECEIVER_SUM=`echo "$SENDER_SUM $RECEIVER" | awk '{print $1+$2}'`

                done
		RECEIVER_SUM=`echo "$RECEIVER_SUM $count" | awk '{print $1/$2}' `
                echo "$RECEIVER_SUM $RECEIVER_UNIT"
        done
done

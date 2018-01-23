#!/bin/bash 
#
# Program:
#        get test results
# History:
#        wulm 2017/11/28 1.0v
#

. ./common.sh
if [[ $1 != NULL ]]; then
	LOG_DIR=$1	
fi
SPLITER="\t"

declare -a STR

if [ "$TEST_MODE" = "0" ];then
	TAZYU=$TAZYU_NATIVE
else
	TAZYU=$TAZYU_GUEST
fi


SUBDIRS=`ls $LOG_DIR`
# Output the header
echo -n "         "
for SUBDIR in $SUBDIRS; do
	echo -n -e "$SUBDIR" "$SPLITER"
done
echo "AVG" 

# Get the performance data
for SUBDIR in $SUBDIRS; do
	for PROC in $TAZYU; do
		[ ! -d $LOG_DIR/$SUBDIR/$PROC-tazyu ] && break

		PROC_VALUE=`expr $PROC`
		MFLOPS=0
		for((i=0;i<PROC;i++))
		do
			FILE=$LOG_DIR/$SUBDIR/$PROC-tazyu/himeno-$i.log
			RESULT=`grep "MFLOPS measured :" $FILE | awk '{printf("%.2f", $4)}'`
			RESULT=`echo $RESULT`
			MFLOPS=`echo "$MFLOPS $RESULT" | awk '{printf("%.2f", $1+$2)}'`
		done

		TMP=`echo ${STR[$PROC_VALUE]}`
		if [ -z "$TMP" ]; then
			STR[$PROC_VALUE]=`echo $MFLOPS`
		else
			STR[$PROC_VALUE]="`echo ${STR[$PROC_VALUE]}` $SPLITER $MFLOPS"
		fi
	done
done

# Print the formatted result
for PROC in $TAZYU; do
	PROC_VALUE=`expr $PROC`
	echo -n "tazyu=$PROC  "
	echo -n -e ${STR[$PROC_VALUE]}
	#results_avg=`cat $LOG_DIR/*/${PROC}-tazyu/himeno-* | grep "MFLOPS measured :" | awk -v test_times="$TEST_TIMES" 'BEGIN{sum=0}{sum=sum+$4}END{print sum/test_times}'`
	cat $LOG_DIR/*/${PROC}-tazyu/himeno-* | grep "MFLOPS measured :" | awk -v test_times="$TEST_TIMES" 'BEGIN{sum=0}{sum=sum+$4}END{printf("\t%.2f\n", sum/test_times)}'
	#echo " $results_avg"
done

unset STR

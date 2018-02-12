# !/bin/sh
#----------------------------------------------------------------------------
# Output usage
#----------------------------------------------------------------------------
LP_help() {
        cat <<EOT
USAGE:
        EXAMPLE:
        ./threshold_check.sh  sar_file output_dir check_item threshold_num
        # input is the input binary sar data collected by PerfInfoCollector.sh
        # output is the output directory
	# CHECK_ITEM is the item that you want to check.you can use: mem,cache,network,cpu,disk
	# THRESOLD is the THRESOLD number. 
	# example:
	 ./threshold_check.sh 1108/sar-A_1108142559 test cpu 80
	 ./threshold_check.sh 1108/sar-A_1108142559 test mem 70
	 ./threshold_check.sh 1108/sar-A_1108142559 test cache 20
	 ./threshold_check.sh 1108/sar-A_1108142559 test disk 50
	 ./threshold_check.sh 1108/sar-A_1108142559 test network 1024
EOT
}

INPUT=$1        # the input binary sar data
OUTPUT=$2
CHECK_ITEM=$3   #  mem|cache|network|cpu|disk
THRESOLD=$4

TIME=`date +%m%d%H%M%S`
if [ ! ${OUTPUT} ];then
        echo "INFO: Please enter the  OUTPUT  directory . "
        LP_help
        exit 0


else
        if [[ ${INPUT} =~ sar\-A\_[0-9]+$ ]]; then
                TMP_DIR=`basename ${INPUT}`
        else
                echo "INFO: input file is not the format of collected data(sar-A_mmddHHMMSS)!"
                LP_help
                exit 0
        fi
fi

if [ ! ${OUTPUT} ];then
        echo "INFO: Please enter the  OUTPUT  directory . "
        LP_help
        exit 0


else
        if [[ ! -d ${OUTPUT} ]]; then
                mkdir ${OUTPUT} >/dev/null 2>&1
        fi
fi

if [ !  ${CHECK_ITEM} ];then
        echo "INFO: Please enter the  CHECK_ITEM. "
        LP_help
        exit 0

else
        if [ ${CHECK_ITEM} != "mem" ] &&  [ ${CHECK_ITEM} != "cache" ]  && [ ${CHECK_ITEM} != "network" ] && [ ${CHECK_ITEM} != "cpu" ] && [ ${CHECK_ITEM} !=  "disk" ];then
        echo "You should use "mem" , "cache" , "cpu" ,"network" ,"disk"."
        LP_help
        exit 0
        fi
fi

if [ !  ${THRESOLD} ];then
        echo "INFO: Please enter the  THRESOLD number "
        LP_help
        exit 0

fi

FREE_THRESOLD=`expr 100 - $THRESOLD`
if [ $CHECK_ITEM = "mem" ]; then


	###################################
	#check memory uesd
	###################################
	sar -r  -f $INPUT | grep -v Average | awk ' NR==3 {print  $0 } NR>3 {print  $0}'  > tmp_$TIME
	tmp_raws=`awk -v i=$THRESOLD 'NR > 1 &&  $5 >= i {print $0} ' tmp_$TIME | wc -l`
	if [ $tmp_raws == 0 ];then
		echo " $tmp_raws raws :   memory usage were larger  than  ${THRESOLD}%. "
	else
	
        	echo " $tmp_raws raws :   memory usage were larger  than  ${THRESOLD}%. Please check logfile ./${OUTPUT}/MEMUSED_${THRESOLD}_$TIME" 
	        awk -v i=$THRESOLD 'NR==1 {print $0} $5 >= i {print $0} ' tmp_$TIME > ${OUTPUT}/MEMUSED_${THRESOLD}_$TIME
	fi
	rm -rf tmp_$TIME

fi



if [ $CHECK_ITEM = "cache" ]; then


	###################################
	#check cache  used
	###################################
	sar -r  -f $INPUT | grep -v Average | awk ' NR==3 {print  $0 "\t" "%cacheused" } NR>3 {print  $0 "\t" ($7 / ($3+$4))*100}'  > tmp_$TIME
	tmp_raws=`awk -v CACHE_THRESOLD=$THRESOLD ' $NF >= CACHE_THRESOLD {print $0} ' tmp_$TIME | wc -l`
	if [ $tmp_raws = "0" ];then
        	echo " $tmp_raws raws :   cache usage were larger  than  ${THRESOLD}%."
	else

        	echo " $tmp_raws raws :   cache usage were larger  than  ${THRESOLD}%. Please check logfile ./${OUTPUT}/CACHE_${THRESOLD}_$TIME"
        	awk -v CACHE_THRESOLD=$THRESOLD 'NR==1 {print $0} $NF >= CACHE_THRESOLD {print $0} ' tmp_$TIME  > ${OUTPUT}/CACHE_${THRESOLD}_$TIME
	fi
	rm -rf tmp_$TIME

fi

if [ $CHECK_ITEM = "network" ]; then
	###################################
	#check network 
	###################################
	tmp_raws=` sar -n ALL -f $INPUT | awk ' $1 == "Average:"   {print NR  }'|  awk ' NR==1 {print $1}' `
	sar -n ALL -f $INPUT |  awk -v i=$tmp_raws ' NR> 2 &&  NR < i {print $0} ' >  tmp_$TIME

	DEV_LIST=`cat tmp_$TIME | awk 'NR > 1 {print $3}' | sort -u`

	for DEVICE in $DEV_LIST
	do
        #	echo "chech rxkB/s "
               	tmp_raws_rxkB=`awk -v device=$DEVICE -v a=$THRESOLD '$3 == device  && $6 > a  {print $0} ' tmp_$TIME | wc -l  `
	
		if [ $tmp_raws_rxkB = "0" ];then
	       		echo " $tmp_raws_rxkB raws :  $DEVICE's txkB/s  were more than  ${THRESOLD} rxkB/s . "
		else

        		echo " $tmp_raws_rxkB raws :  $DEVICE's  rxkB/s  were more than  ${THRESOLD} rxkB/s  . Please check logfile ./${OUTPUT}/network_${DEVICE}_rxkB_${THRESOLD}_$TIME"
		        awk -v device=$DEVICE -v a=$THRESOLD 'NR==1 {print $0} $3 == device  && $6 > a  {print $0} ' tmp_$TIME  > ${OUTPUT}/network_${DEVICE}_rxkB_${THRESOLD}_$TIME
		fi
	
	#	echo "chech txkB/s"
                tmp_raws_txkB=`awk -v device=$DEVICE -v a=$THRESOLD '$3 == device  && $7 > a  {print $0} ' tmp_$TIME | wc -l  `
                if [ $tmp_raws_txkB = "0" ];then
                        echo " $tmp_raws_txkB raws :   $DEVICE's  txkB/s were  more than  ${THRESOLD} txkB/s. "
                else
                        echo " $tmp_raws_txkB raws :    $DEVICE's txkB/s were  more than  ${THRESOLD} txkB/s. Please check logfile ./${OUTPUT}/network_${DEVICE}_txkB_${THRESOLD}_$TIME"
                        awk -v device=$DEVICE -v a=$THRESOLD 'NR==1 {print $0} $3 == device  && $7 > a  {print $0} ' tmp_$TIME  > ${OUTPUT}/network_${DEVICE}_txkB_${THRESOLD}_$TIME
                fi

	done

	rm -rf tmp_$TIME
fi

if [ $CHECK_ITEM = "cpu" ]; then
	#################################
	# get the cpu threshold
	# cpu  idle  : 0% ~ 10%
	################################

	function check_cpu_idle()
	{
        	local cpu_list=$1
	        local idle_range_start
        	local idle_range_end
	        local check_range=$2
	        #local check_range="10 20 30 40 50 60 70 80 90 100"
	        for range in $check_range
        	do
                	idle_range_start=0
	                idle_range_end=`expr 100 - $range `
			use_range_end=100
        	        tmp_count=`sar -P ALL -f $INPUT | grep -v "Average" |  awk -v  i=$idle_range_start -v j=$idle_range_end  -v k=$cpu_list ' $3 == k {if($9 > i && $9 <= j) print $0}'  | wc -l`

                	if [ $tmp_count -eq 0 ];then
                        	echo " $tmp_count raws : CPU_NUM_$cpu_list  usage in  ${range}% ~ ${use_range_end}% ." 
	               else
        	                echo " $tmp_count raws : CPU_NUM_$cpu_list  usage in ${range}% ~ ${use_range_end}% . please check logfiel ./${OUTPUT}/cpu-$cpu_list-${range}-${use_range_end}_$TIME " 
                	        sar -P ALL -f $INPUT | grep -v "Average" |  awk -v  i=$idle_range_start -v j=$idle_range_end  -v k=$cpu_list ' NR==3 {print $0} $3 == k {if($9 > i && $9 <= j) print $0}' > ${OUTPUT}/cpu-$cpu_list-${range}-${use_range_end}_$TIME
	                fi

        	done
	}

	CPU_LISTS=`sar -P ALL  -f $INPUT | grep -v "Average" |grep -v "CPU" | awk 'NR > 3 {print $3} ' | sort -nu`
	for cpu_list in $CPU_LISTS
	do
        	check_cpu_idle $cpu_list $THRESOLD	
	done

fi

if [ $CHECK_ITEM = "disk" ]; then
        #################################
        # chech disk  threshold
        ################################

        function check_disk_util()
        {
                local disk_list=$1
                local util_range_start
                local util_range_end
                local check_range=$2
                for range in $check_range
                do
                        util_range_start=$check_range
                        util_range_end=100
                        tmp_count=`sar -d -f $INPUT | grep -v "Average" |  awk -v  i=$util_range_start -v j=$util_range_end  -v k=$disk_list ' $3 == k {if($11 > i && $11 <= j) print $0}'  | wc -l`

                        if [ $tmp_count -eq 0 ];then
                                echo " $tmp_count raws : DEV ${disk_list} util% in  ${util_range_start}% ~ ${util_range_end}% ."
                       else
                                echo " $tmp_count raws : DEV ${disk_list}  util% in ${util_range_start}% ~ ${util_range_end}% . please check logfiel ./${OUTPUT}/disk-${disk_list}-${util_range_start}-${util_range_end}_$TIME "
                                sar -d -f $INPUT | grep -v "Average" |  awk -v  i=$util_range_start -v j=$util_range_end  -v k=$disk_list ' NR==3 {print $0} $3 == k {if($11 > i && $11 <= j) print $0}' > ${OUTPUT}/disk-${disk_list}-${util_range_start}-${util_range_end}_$TIME
                        fi

                done
        }

        DISK_LISTS=`sar -d -f $INPUT | grep -v "Average"  | awk 'NR > 3 {print $3} ' | sort -nu`
        for disk_list in $DISK_LISTS
        do
                check_disk_util $disk_list $THRESOLD
        done

fi


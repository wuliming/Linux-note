#!/bin/bash 

#############################################################
# The following can be edited to set the object and threshold of the check
#############################################################
CHECK_MODE="all"            # cpu | memory | dev | network | process | irq | swap | page |  all
CHECK_CPU_INFO="all"        # usr | sys | irq | soft | guest | idle | all
CHECK_MEMORY_INFO="all"     # memused | kbbuffers | kbcached | commit | all
CHECK_DEV_INFO="all"        # tps | rd_sec | wr_sec | all
CHECK_NETWORK_INFO="all"    # rxkB | txkB | all
CHECK_PROCESS_INFO="all"    # proc | cswch | all
CHECK_SWAP_INFO="all"       # pswpin | pswpout | all
CHECK_PAGE_INFO="all"       # pgpgin | pgpgout | fault | majflt | pgfree | all
CHECK_THRESHOLD=5          # set threshold : [1,100]
CHECK_THRESHOLD_FLAG="all"   # up | down | all


#############################################################
# The following are global variables, can not edit
#############################################################
CHECK_FILE=$1
CHECK_LIST=""
BEGIN_LINE=0
END_LINE=0


#############################################################
# help_f function,display help information
#############################################################
function help_f()
{
	echo "Usage: ./Mutation_check.sh sar_filename"
}


#############################################################
# The following functions are used to initialize the global variables
# The global variable contains the following information:
# 	cpu_info
#	dev_info
#	memory_info
#	network_info
#	process_info
#	irq_info
#	swap_info
#	page_info
#############################################################
function line_init()
{
	local flag=$1
	BEGIN_LINE=`cat $CHECK_FILE | grep -n "$flag" | sed -n '1p' |  awk 'BEGIN{FS=":"}{print $1}'`
	BEGIN_LINE=`expr $BEGIN_LINE + 1`
	END_LINE=`cat $CHECK_FILE | sed -n "${BEGIN_LINE},$ p" | grep -n Average | sed -n '1p' | awk 'BEGIN{FS=":"}{print $1}'`
	END_LINE=`expr $BEGIN_LINE + $END_LINE`
	END_LINE=`expr $END_LINE - 3`
	CHECK_LIST=`cat $CHECK_FILE | sed -n "${BEGIN_LINE},${END_LINE}p" | awk '{print $2}' | sort -u` 
}
function cpu_info_init()
{
	line_init "usr"
}
function dev_info_init()
{
	line_init "rd_sec"
}

function memory_info_init()
{
	line_init "kbmemfree"
}
function network_info_init()
{
	line_init "rxpck"
}
function process_info_init()
{
	line_init "proc"
}
function irq_info_init()
{
	line_init "INTR"
}
function swap_info_init()
{
	line_init "pswpin"
}
function page_info_init()
{
	line_init "pgpgin"
}



#############################################################
# The following functions are used for check system information,
# If the rate of change exceeds the threshold value, Give prompt information.
# prompt information contains the following:
#	time
#	system variable
#	old_value
#	new_value
#	change value
# The algorithm for check is as follows:
#	if | (new_value-old_value) | > CHECK_THRESHOLD*avg
#	then print prompt information
#############################################################
function check_cmd_set()
{
	local obj=$1
	local mode=$2
	local list_number=$3
	local number=$4
	local avg
	AVG_CMD="cat $CHECK_FILE | sed -n \"${BEGIN_LINE},${END_LINE}p\" | grep \" $number \" | awk 'BEGIN{diff=0;sum=0;num=0;old_value=0;new_value=0;flag=0}{if(flag==0){old_value=\$$list_number;flag=1}else{new_value=\$$list_number;diff=old_value-new_value;sum=sqrt(diff*diff)+sum;num++;old_value=new_value}}END{print sum/num}'"
	avg=`eval $AVG_CMD`
	local check_threshold=`echo "$CHECK_THRESHOLD $avg" | awk '{if($2>1){print $1*$2}else{print $1}}'`
	CMD="cat $CHECK_FILE | sed -n \"${BEGIN_LINE},${END_LINE}p\" | grep \" $number \" | awk -v value=$check_threshold -v $obj=$number -v mode=$mode 'BEGIN{old_value=0;new_value=0;flag=0}{if(flag==0){old_value=\$$list_number;flag=1}else{new_value=\$$list_number;if((new_value-old_value)>value || (old_value-new_value)>value){printf(\"%-10s $obj=%-4s  %6s : old_value=%-s new_value=%-s  >>> %s\\n\",\$1,$obj,mode,old_value,new_value,new_value-old_value)};old_value=new_value}}'"
	eval $CMD
}

function check_cpu_usr()
{
	local cpu=$1
	local obj="cpu"
	local mode="usr"
	local list_number=3
	check_cmd_set $obj $mode $list_number $cpu
}
function check_cpu_sys()
{
	local cpu=$1
	local obj="cpu"
	local mode="sys"
	local list_number=5
	check_cmd_set $obj $mode $list_number $cpu
}	
function check_cpu_irq()
{
	local cpu=$1
	local obj="cpu"
	local mode="irq"
	local list_number=8
	check_cmd_set $obj $mode $list_number $cpu
}	
function check_cpu_soft()
{
	local cpu=$1
	local obj="cpu"
	local mode="soft"
	local list_number=9
	check_cmd_set $obj $mode $list_number $cpu
}	
function check_cpu_guest()
{
	local cpu=$1
	local obj="cpu"
	local mode="guest"
	local list_number=10
	check_cmd_set $obj $mode $list_number $cpu
}	
function check_cpu_idle()
{
	local cpu=$1
	local obj="cpu"
	local mode="idle"
	local list_number=12
	check_cmd_set $obj $mode $list_number $cpu
}	
function check_memory_memused()
{
	local obj="memory"
	local mode="memused"
	local list_number=4
	check_cmd_set $obj $mode $list_number
}
function check_memory_kbbuffers()
{
	local obj="memory"
	local mode="kbbuffers"
	local list_number=5
	check_cmd_set $obj $mode $list_number
}
function check_memory_kbcached()
{
	local obj="memory"
	local mode="kbcached"
	local list_number=6
	check_cmd_set $obj $mode $list_number
}
function check_memory_commit()
{
	local obj="memory"
	local mode="commit"
	local list_number=8
	check_cmd_set $obj $mode $list_number
}
function check_dev_tps()
{
	local dev=$1
	local obj="dev"
	local mode="dev_tps"
	local list_number=3
	check_cmd_set $obj $mode $list_number $dev
}
function check_dev_rd_sec()
{
	local dev=$1
	local obj="dev"
	local mode="dev_rd_sec"
	local list_number=4
	check_cmd_set $obj $mode $list_number $dev
}
function check_dev_wr_sec()
{
	local dev=$1
	local obj="dev"
	local mode="dev_wr_sec"
	local list_number=5
	check_cmd_set $obj $mode $list_number $dev
}
function check_network_rxkB()
{
	local network=$1
	local obj="network"
	local mode="network_rxkB"
	local list_number=5
	check_cmd_set $obj $mode $list_number $network
}
function check_network_txkB()
{
	local network=$1
	local obj="network"
	local mode="network_txkB"
	local list_number=6
	check_cmd_set $obj $mode $list_number $network
}
function check_process_proc()
{
	local obj="process"
	local mode="proc"
	local list_number=2
	check_cmd_set $obj $mode $list_number
}
function check_process_cswch()
{
	local obj="process"
	local mode="cswch"
	local list_number=3
	check_cmd_set $obj $mode $list_number
}
function check_irq_sum()
{
	local obj="irq"
	local mode="intr_sum"
	local list_number=3
	check_cmd_set $obj $mode $list_number
}
function check_swap_pswpin()
{
	local obj="swap"
	local mode="pswpin"
	local list_number=2
	check_cmd_set $obj $mode $list_number
}
function check_swap_pswpout()
{
	local obj="swap"
	local mode="pswpout"
	local list_number=3
	check_cmd_set $obj $mode $list_number
}
function check_page_pgpgin()
{
	local obj="page"
	local mode="pgpgin"
	local list_number=2
	check_cmd_set $obj $mode $list_number
}
function check_page_pgpgout()
{
	local obj="page"
	local mode="pgpgout"
	local list_number=3
	check_cmd_set $obj $mode $list_number
}
function check_page_fault()
{
	local obj="page"
	local mode="fault"
	local list_number=4
	check_cmd_set $obj $mode $list_number
}
function check_page_majflt()
{
	local obj="page"
	local mode="majflt"
	local list_number=5
	check_cmd_set $obj $mode $list_number
}
function check_page_pgfree()
{
	local obj="page"
	local mode="pgfree"
	local list_number=6
	check_cmd_set $obj $mode $list_number
}



#############################################################
# 
#############################################################
function set_list()
{
	local obj=$1
	local list=""
	local input
	local number
	echo "Set $obj check"
	echo "Select a check's $obj number"
	echo "List of selectable ${obj}s:"
	echo $CHECK_LIST
	echo "ALL"
	echo -n "Please enter the $obj number of the check[default=ALL]:"
	read input
	if [ "$input" = "ALL" ] || [ "$input" = "" ];then
		list=$CHECK_LIST
	else
		for number in $CHECK_LIST
		do
			if [ "$input" = "$number" ];then
				list=$input
				CHECK_LIST=$list
			fi
		done
	fi
	if [ "$list" = "" ];then
		set_list $obj
	fi
}



#############################################################
#
#############################################################
function check_cpu()
{
	local cpu=$1
	local cpu_info=$CHECK_CPU_INFO
	case $cpu_info in
		usr)
	check_cpu_usr $cpu
	;;
		sys)
	check_cpu_sys $cpu
	;;
		irq)
	check_cpu_irq $cpu
	;;
		soft)
	check_cpu_soft $cpu
	;;
		guest)
	check_cpu_guest $cpu
	;;
		idle)
	check_cpu_idle $cpu
	;;
		all)
	check_cpu_usr $cpu
	check_cpu_sys $cpu
	check_cpu_irq $cpu
	check_cpu_soft $cpu
	check_cpu_guest $cpu
	check_cpu_idle $cpu
	;;
		*)
	echo "Please check CHECK_CPU_INFO"
	exit
	;;
	esac
}
function check_cpus()
{
	local cpu
	cpu_info_init
#	if [ "$1" != "all" ];then
#		set_list "cpu"
#	fi
	for cpu in $CHECK_LIST
	do
		check_cpu $cpu
	done
}
function check_memory()
{
	local memory_info=$CHECK_MEMORY_INFO
	memory_info_init
	case $memory_info in
		memused)
	check_memory_memused
	;;
		kbbuffers)
	check_memory_kbbuffers
	;;
		kbcached)
	check_memory_kbcached
	;;
		commit)
	check_memory_commit
	;;
		all)
	check_memory_memused
	check_memory_kbbuffers
	check_memory_kbcached
	check_memory_commit
	;;
		*)
	echo "Please check CHECK_MEMORY_INFO"
	exit
	;;
	esac	
}
function check_dev()
{
	local dev=$1
	local dev_info=$CHECK_DEV_INFO
	case $dev_info in
		tps)
	check_dev_tps $dev
	;;
		rd_sec)
	check_dev_rd_sec $dev
	;;
		wr_sec)
	check_dev_wr_sec $dev
	;;
		all)
	check_dev_tps $dev
	check_dev_rd_sec $dev
	check_dev_wr_sec $dev
	;;
		*)
	echo "Please check CHECK_DEV_INFO"
	exit
	;;
	esac
}
function check_devs()
{
	local dev
	dev_info_init
#	if [ "$1" != "all" ];then
#		set_list "dev"
#	fi
	for dev in $CHECK_LIST
	do
		check_dev $dev
	done
}
function check_network()
{
	local network=$1
	local network_info=$CHECK_NETWORK_INFO
	case $network_info in
		tps)
	check_network_rxkB $network
	;;
		rd_sec)
	check_network_txkB $network
	;;
		all)
	check_network_rxkB $network
	check_network_txkB $network
	;;
		*)
	echo "Please check CHECK_NETWORK_INFO"
	exit
	;;
	esac
}
function check_networks()
{
	local network
	network_info_init
#	if [ "$1" != "all" ];then
#		set_list "network"
#	fi
	for network in $CHECK_LIST
	do
		check_network $network
	done
}
function check_process()
{
	local process_info=$CHECK_PROCESS_INFO
	process_info_init
	case $process_info in
		proc)
	check_process_proc
	;;
		cswch)
	check_process_cswch
	;;
		all)
	check_process_proc
	check_process_cswch
	;;
		*)
	echo "Please check CHECK_PROCESS_INFO"
	exit
	;;
	esac
	
}
function check_irq()
{
	irq_info_init
	check_irq_sum
}
function check_swap()
{
	local swap_info=$CHECK_SWAP_INFO
	swap_info_init
	case $swap_info in
		pswpin)
	check_swap_pswpin
	;;
		pswpout)
	check_swap_pswpout
	;;
		all)
	check_swap_pswpin
	check_swap_pswpout
	;;
		*)
	echo "Please check CHECK_SWAP_INFO"
	exit
	;;
	esac
}
function check_page()
{
	local page_info=$CHECK_PAGE_INFO
	page_info_init
	case $page_info in
		pgpgin)
	check_page_pgpgin
	;;
		pgpgout)
	check_page_pgpgout
	;;
		fault)
	check_page_fault
	;;
		majflt)
	check_page_majflt
	;;
		pgfree)
	check_page_pgfree
	;;
		all)
	check_page_pgpgin
	check_page_pgpgout
	check_page_fault
	check_page_majflt
	check_page_pgfree
	;;
		*)
	echo "Please check CHECK_PAGE_INFO"
	exit
	;;
	esac	
}


#############################################################
# main function
#############################################################
function main()
{
	case $CHECK_MODE in 
		cpu)
	check_cpus
	;;
		dev)
	check_devs
	;;
		memory)
	check_memory
	;;
		network)
	check_networks
	;;
		process)
	check_process
	;;
		irq)
	check_irq
	;;
		swap)
	check_swap
	;;
		page)
	check_page
	;;
		all)
	check_cpus all
	check_devs all
	check_memory 
	check_networks all
	check_process
	check_irq
	check_swap
	check_page	
	;;
		*)
	echo "please check CHECK_MODE"
	exit
	;;
	esac
}

#############################################################
# Program entrance
#############################################################
if [ $# -ne 1 ];then
	help_f
	exit
else
	if [ -f $CHECK_FILE ];then
		case  $CHECK_THRESHOLD_FLAG in
			up)
		main | grep -v "-"
		;;
			down)
		main | grep  "-"
		;;
			all)
		main 
		;;
			*)
		echo "Please check CHECK_THRESHOLD_FLAG"
		;;
		esac
	else
		echo "Please enter the correct sar file name"
		help_f
		exit
	fi
fi

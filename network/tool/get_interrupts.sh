#!/bin/sh 

#EX: ./get_interrupts.sh 0201075607/log-server/lenth-256K/round-1/tazyu-1/0201075533/getperfinfo/interrupts_0201075533  enp4s0f0 12
#$1		file directory
#$2		NIC name: eth1
#$3		Cores or the max X of eth-RxTx-$X
#$4		0: kvm  1: Native

LANG=C
export LANG
PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH
FILE=$1
NIC=$2
if [ -z $3 ];then
	CORES=`lscpu | grep "^CPU(s)" | awk '{print $2}'`
else
	CORES=$3
fi

#FILE=`find $1 -name "interrupt*|*irq*"`
echo ${FILE}
do_get_interrupt(){
	cat ${FILE} | \
	grep "${1}$"  | \
	awk -v cores=${CORES}  'BEGIN {
			interrupt_no=0;
			sum=0;
			start[cores];
			end[cores];
		}
		{
			if(NR==1){ 
				for(i=0; i <cores; i++) {
					start[i]=$(i+2);
				}
				interrupt_no=$1;
				dev=$NF;
			}
		}
		END {
			for(i=0; i<cores; i++) {
				end[i]=$(i+2);
				if( end[i]-start[i] > 0 ) {
					printf("interupt NO.: %-4d\tcpu: %-3d\t interrupts: %-10d\t device: %s\t %d -> %d\n", \
						 interrupt_no, i, end[i]-start[i], dev, start[i], end[i]);
				}
			}
		}'
}

do_get_interrupt_all(){
	cat ${FILE} | \
	grep -E "*${1}*"  | \
	awk -v cores=${CORES}  'BEGIN {
			interrupt_no=0;
			sum=0;
			start[][cores];
			end[][cores];
		}
		{
			if(NR==1){ 
				for(i=0; i <cores; i++) {
					start[i]=$(i+2);
				}
				interrupt_no=$1;
				dev=$NF;
			}
		}
		END {
			for(i=0; i<cores; i++) {
				end[i]=$(i+2);
				if( end[i]-start[i] > 0 ) {
					printf("interupt NO.: %-4d\tcpu: %-3d\t interrupts: %-10d\t device: %s\t %d -> %d\n", \
						 interrupt_no, i, end[i]-start[i], dev, start[i], end[i]);
				}
			}
		}'
}
declare -i i=0

do_get_interrupt ${NIC} 
#lscpu | grep Hypervisor
flag=$4
if [[ $flag = 0 ]]; then
	do_get_interrupt ${NIC}-tx-${i}
	do_get_interrupt ${NIC}-rx-${i}
	#do_get_interrupt_all ${NIC}
else
	for((i; i<${CORES}; i++))
	do
		do_get_interrupt ${NIC}-TxRx-${i}
	done

fi

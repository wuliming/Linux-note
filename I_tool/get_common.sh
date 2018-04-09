#!/bin/bash  
set -x
date
echo "kernel info:"  
cat /proc/cmdline
uname -a
getenforce
for service in firewalld auditd irqbalance ksm
do
  systemctl is-active $service
done
ps aux | grep ge[t]  | grep -v qemu
ps aux | fgrep ".sh" | grep -v qemu
ps aux | grep X      | grep -v qemu

set +x

echo "Bios info:"  
dmidecode -t bios | grep -iE "Vendor|Version|Release"

echo "Product name:"
dmidecode -t system | grep -i Product
dmidecode -t chassis | grep -i Version

echo "Processor info:"
Siblings=`grep "siblings" /proc/cpuinfo | uniq | awk '{print $3}'`
Cores=`grep "cpu cores" /proc/cpuinfo | uniq | awk '{print $4}'`
# when machine is PC, it's invalid
if [ ${Siblings} = ${Cores} ]; then
	echo -e "\tHT:\tOFF"
else
	echo -e "\tHT:\tON"
fi
dmidecode -t processor | grep -iE "version|speed|Core" | grep -v Multi | sort -u
# generally, when "Thread(s) per core:    2"   -> HT_ON
# "Thread(s) per core:    1"  		       -> HT_OFF
lscpu | awk '{printf("\t%s\n", $0)}'
numactl -H | awk '{printf("\t%s\n", $0)}'

echo "Disk Info:"  
parted -l | grep -Ei "Disk /dev/sd|sector size" | awk -F ',' '{printf("\t%s\n",$1)}' | sort -u
dmesg | grep sd* | grep -i "write cache" | awk \
'{if(match($8, "enabled")) printf("\t%s is write back\n", $5); \
else printf("\t%s is write through\n", $5)}'  2>/dev/null

echo "Network Info:"  
lspci | grep Ethernet | awk '{printf("\t%s\n", $0)}'
for eth in  `ip a | grep -E "^[1-9]" | awk -F': |:' '{print $2}'`
do
	ethtool $eth 
done | grep -iE "Settings|Speed|Duplex|Auto-negotiation|detected" | awk '{printf("\t%s\n", $0)}'
 
echo "Memory Info:"  
#dmidecode | grep -A5 "Memory Device" |grep -i "  *Size" |grep -v "No"
echo -e "\tMemory number:\t"`dmidecode | grep -A5 "Memory Device" | grep -i "  *Size" | grep -v No |wc -l`
dmidecode -t memory | grep -iE "type:|size|Speed|Manufacturer" | grep -Ev "No|Unknown|Error"

echo "Power Info:"
cpupower info | awk '{ printf("\t%s\n", $0) }'
cpupower frequency-info | awk '{ printf("\t%s\n", $0) }'
cpupower -c all idle-info | awk '{ printf("\t%s\n", $0) }'

echo "IRQ affinity Info:"
find /proc/irq -name smp_affinity_list -exec echo {} \; -exec cat {} \;  | awk '{ printf("\t%s\n", $0) }'

echo "KVM Info:"
virt-what | awk '{ printf("\t%s\n", $0) }'



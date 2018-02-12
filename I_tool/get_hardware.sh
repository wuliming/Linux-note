#!/bin/bash  
echo "Bios info:"  
dmidecode -t bios | grep -iE "Vendor|Version|Release"

echo "Product name:"
dmidecode -t system | grep -i Product
dmidecode -t chassis | grep -i Version

echo "Processor info:"
dmidecode -t processor | grep -iE "version|speed|Core" | grep -v Multi | sort -u

echo "Disk Info:"  
parted -l|grep 'Disk /dev/sd'|awk -F ',' '{print "  ",$1}'  

echo "Network Info:"  
lspci | grep Ethernet 
 
echo "Memory Info:"  
#dmidecode | grep -A5 "Memory Device" |grep -i "  *Size" |grep -v "No"
dmidecode -t memory | grep -iE "type:|size|Speed|Manufacturer" | grep -Ev "No|Unknown|Error"
echo "Memory number:"`dmidecode | grep -A5 "Memory Device" | grep -i "  *Size" | grep -v No |wc -l`


# 1: create 
# 2: remove 
# 3: start 
# 4: cpu pin
# 5: shutdown
# 6: print ip
# 7: cpu overload
FLAG=$1      # 1: create  2: remove 3: start 4: cpu pin 5: shutdown  6: print ip
VM_COUNT=$2  # vm count
IMG_PATH="/mnt"  # image path
START_NUM=$3
OVER_LOAD=$4
# undefine the vms
case $FLAG in
# create the vms
1)	for num in `seq ${START_NUM} $VM_COUNT`
	do
		if [[ num==1 ]]; then
			virsh shutdown vm0
			sleep 3
		fi
		virt-clone --original vm0 --name vm${num} --file ${IMG_PATH}/rhel7.2_${num}.img
	        usleep  3200000
	done;;
2)	for num in `seq ${START_NUM} $VM_COUNT`
	do
		virsh undefine vm${num}
		virsh shutdown vm${num}
		rm -rf ${IMG_PATH}/rhel7.2_${num}.img
	done;;
3)	for num in `seq ${START_NUM} $VM_COUNT`
	do
		virsh start vm${num}
	done;;
4)	for num in `seq $VM_COUNT`
	do
		virsh dumpxml vm${num} > vm${num}.xml
		sed -i '7i\  <cputune>\' vm${num}.xml
		sed -r -i "8i\    <vcpupin vcpu='0' cpuset='${num}'/>" vm${num}.xml
		sed -i '9i\  </cputune>\' vm${num}.xml
		virsh define vm${num}.xml
	done;;
5)	for num in `seq ${START_NUM} $VM_COUNT`
	do
		virsh shutdown vm${num}
	done;;
6)	for num in `seq $VM_COUNT`
	do
		ip=`virsh domifaddr vm${num} | tail -2 |  sed '$d' | awk -F"[/]" '{print $1}' | awk '{print $4}'`
		echo ${ip}
#		sshpass -p rootroot scp -r /root/.ssh/authorized_keys root@${ip}:/root/.ssh
		#virsh domifaddr vm${num} | tail -2 |  sed '$d' | awk '{print substr($4,0,15)}'
	done;;

# now unuseable for konwhosts file has not host ip
7)	for num in `seq $VM_COUNT`
	do
		ip=`virsh domifaddr vm${num} | tail -2 |  sed '$d' | awk -F"[/]" '{print $1}' | awk '{print $4}'`
		echo ${ip}
		sshpass -p rootroot ssh ${ip} "cd /home/cpulimit-1.1.1; ./start_tunning.sh 1 40;" &
		sshpass -p rootroot ssh ${ip} "cd /home/mem_usage_setting; ./start_tunning.sh 80 2;" &
	done
esac

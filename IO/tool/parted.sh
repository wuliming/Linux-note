#!/bin/sh

#EX1: parted the sda to 3 parttions
#./parted.sh sda 3
#EX2: parted the sda to 3 xfs parttions

#declare -i DISK_SIZE00=40000	# partion size MB 
declare -i DISK_SIZE=20		# partion size % 
LIST=$1				# disk list
DISK_NUM=$2			# partion number
if [[ -z $3 ]]; then
	TYPE="xfs"
else
	TYPE=$3
fi

echo "---will format the ${LIST} to ${TYPE}-----"
set -x
for F in $LIST
do
	LIST=`parted /dev/$F p | awk '{print $1}'`
	for NUMBER in `echo $LIST`
	do
		echo $NUMBER | grep ^[0-9]
		if [ $? = 0 ]; then
			parted /dev/$F rm $NUMBER
		fi
	done

	parted -s /dev/$F p

	echo "parted -s /dev/$F mklabel msdos"
	parted -s /dev/$F mklabel msdos

	declare -i COUNT=1
	#declare -i optimal_io_size=`cat /sys/block/sde/queue/optimal_io_size`
	#declare -i alignment_offset=`cat /sys/block/sde/alignment_offset`
	#declare -i physical_block_size=`cat /sys/block/sde/queue/physical_block_size`
	#START=(optimal_io_size + alignment_offset)/physical_block_size
	declare -i START=0
	declare -i END=${DISK_SIZE}

	while [ $COUNT -le $DISK_NUM ]
	do
		#echo "parted -s /dev/$F mkpart primary ext2 $START $END"
		parted -s /dev/$F mkpart primary $TYPE ${START}% ${END}%
		if [[ ${TYPE} = "xfs" ]] || [[ ${TYPE} = "btrfs" ]]; then
			mkfs -t $TYPE -f /dev/${F}${COUNT}
		else
			mkfs -t $TYPE /dev/${F}${COUNT}
		fi

		START=END
		END=START+DISK_SIZE

		# clear the dir_index feture
		/sbin/tune2fs -O ^dir_index /dev/${F}${COUNT}

		COUNT=COUNT+1
	done

	# tell kernel's notice, request os to reload partion information
	# -s can display the summary of partion # partprobe -s
	partprobe /dev/${F}  
 
done

exit 0


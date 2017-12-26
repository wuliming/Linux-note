#!/bin/sh

#EX: part the sda to 3 partions
#./parted.sh sda 3

declare -i DISK_SIZE00=40000	# partion size MB 
LIST=$1				# disk list
DISK_NUM=$2			# partion number

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

	echo "parted -s /dev/$F mklabel msdos"
	parted -s /dev/$F mklabel msdos

	declare -i COUNT=1
	declare -i START=0
	declare -i END=$DISK_SIZE00

	while [ $COUNT -le $DISK_NUM ]
	do
		#echo "parted -s /dev/$F mkpart primary ext2 $START $END"
		parted -s /dev/$F mkpart primary ext2 $START $END
		START=END
		END=START+DISK_SIZE00
		COUNT=COUNT+1
	done

	# tell kernel's notice, request os to reload partion information
	# -s can display the summary of partion # partprobe -s
	partprobe /dev/${F}   
done

exit 0


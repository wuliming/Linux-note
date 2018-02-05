#!/bin/sh 
#----------------------------------------------------------------------------
# Output usage
#----------------------------------------------------------------------------
LP_help() {
        cat <<EOT
USAGE:
	EXAMPLE:
	./2csv.sh input_file  output_dir
	# input_file is the input binary sar data collected by PerfInfoCollector.sh
	# output_dir is the directory for csv
EOT
}
	
if [[ $# != 2 ]]; then
	echo "ERROR: specified parameter is wrong!"
	LP_help
	exit
fi

INPUT=$1	# the input binary sar data
OUTPUT=$2	# the output directory
TIME=`date +%m%d%H%M%S`
CPUS=2
if [[ ${INPUT} =~ sar\-A\_[0-9]+$ ]]; then
	TMP_DIR=`basename ${INPUT}`
	TIME=`expr substr "${TMP_DIR}" 7 10`
else
	echo "INFO: input file is not the format of collected data(sar-A_mmddHHMMSS)!"
	LP_help
fi

if [[ ! -d ${OUTPUT} ]]; then
	mkdir ${OUTPUT} >/dev/null 2>&1
fi

# get the real no. of cpus
CPUS=$((`sadf -d -- -u ALL -P ALL 1 1 ${INPUT} | wc -l`-3))

# get the cpu_avg csv file of sar
sadf -d -- -u ALL  ${INPUT} > ${OUTPUT}/cpu_avg_${TIME}.csv  2>&1

# get each cpu usage of sar
for  cpu in `seq 0 ${CPUS}`
do
	sadf -d -- -u ALL -P ${cpu} $INPUT > ${OUTPUT}/cpu_${cpu}_${TIME}.csv  2>&1
done 

# get the memory csv file of sar
sadf -d -- -B ${INPUT} > ${OUTPUT}/mem_${TIME}.csv  2>&1

# get the io csv file of sar
sadf -d -- -d ${INPUT} > ${OUTPUT}/io_${TIME}.csv  2>&1

# get the network csv of sar
sadf -d -- -n DEV ${INPUT} > ${OUTPUT}/network_${TIME}.csv 2>&1

# divide the network csv file
for dev in `sadf -d -- -n DEV ${INPUT} 1 1 | grep -v "#" | awk '{print $3}' | awk -F";" '{print $2}'`
do
	head -1  ${OUTPUT}/network_${TIME}.csv > ${OUTPUT}/${dev}_${TIME}.csv 2>&1
	cat ${OUTPUT}/network_${TIME}.csv | grep ${dev} >> ${OUTPUT}/${dev}_${TIME}.csv 2>&1
done

# delete the network csv file
rm -rf ${OUTPUT}/network_${TIME}.csv

for file in `ls ${OUTPUT}`
do
	sed -i "s/\;/\,/g" ${OUTPUT}/${file}
done

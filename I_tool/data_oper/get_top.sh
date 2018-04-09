#!/bin/sh
# EX: get CPU% > 50% from top.txt
# get_top.sh 50 ../top.txt
# $1		50
# $2		path of file
awk -v v1=$1 '{if(/^top/ || ($9 > v1)) print}' $2 | grep -ivE "^Tasks|^%Cpu|Mem|Swap"

# get only the time and cpu% mem%
awk -v v1=$1 '{if($0 ~ /^top/) printf("%s\t", $3); if($9 > v1 && /^ /) printf("%s\t%s\t%s\n", $9, $10, $12)}' $2 | grep -ivE "^Tasks|^%Cpu|Mem|Swap"

#!/bin/sh
#---------------help-------------------------
# used for "sar -P ALL", can get the cpu usage of sokets
# then the output data can used for MingBai
#---------------changelog--------------------
# 2017/10/17  new
#--------------------------------------------
input=$1
awk 'BEGIN {
		cpu=0;
		sum3=0;
		sum4=0;
		sum5=0;
		sum6=0;
		sum7=0;
		sum8=0;
		flag=0;
	} 
	{	
		while(flag<1) {
			print;
			flag++;
		}
		if( $2 == "CPU") {
			printf "\n";
			print;
		}
		if( $2 != "all") {
		sum3+=$3; 
		sum4+=$4; 
		sum5+=$5; 
		sum6+=$6; 
		sum7+=$7; 
		sum8+=$8; 
		}
		else { print }  
		if( ($2 + 1) % 24 == 0) {
		printf "%-11s   %4d  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f\n", $1, $2, sum3/24, sum4/24, sum5/24, sum6/24, sum7/24, sum8/24; 
		sum3 = sum4=sum5=sum6=sum7=sum8 = 0;
		} 
	}' $input

#!/bin/sh
#---------------help-------------------------
# used for "sar  -u ALL -P ALL", can get the cpu usage of sokets
# then the output data can used for MingBai
# if there is unnecessary date, delete it then use MingBai
# eg:  sed -i '/^2017\/10\/18*/d'  $inputfile
#---------------changelog--------------------

input=$1
awk 'BEGIN {
		cpu=0;
		sum3=0;
		sum4=0;
		sum5=0;
		sum6=0;
		sum7=0;
		sum8=0;
		sum9=0;
		sum10=0;
		sum11=0;
		sum12=0;
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
		sum9+=$9; 
		sum10+=$10; 
		sum11+=$11; 
		sum12+=$12; 
		}
		else { print }  
		if( ($2 + 1) % 24 == 0) {
		printf "%-11s   %4d  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f\n", $1, $2, sum3/24, sum4/24, sum5/24, sum6/24, sum7/24, sum8/24, sum9/24, sum10/24, sum11/24, sum12/24; 
		sum3 = sum4=sum5=sum6=sum7=sum8=sum9=sum10=sum11=sum12 = 0;
		} 
	}' $input

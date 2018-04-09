#!/bin/sh
# add AM and PM into sar text for sar2db

awk '{if((/^Linux/ && NR==1) || !NF || /^Average/) print; \
else if(/^Linux/ && NR>1) ; \
else if(strtonum(substr($1,0,2)) >= 12) {$1=$1" PM"; print;}\
else { $1=$1" AM"; print} }' $1

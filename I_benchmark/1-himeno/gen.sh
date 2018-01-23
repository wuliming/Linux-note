#!/bin/sh

sed -i "/CFLAGS/d" common.sh
sed -i '/GUEST_IP/a\CFLAGS\="DSSMALL"' common.sh
sed -i '/LOG_DIR/d' common.sh
sed -i '/CFLAGS/a\LOG_DIR=".\/log_SS"' common.sh
./test.sh
sed -i "/CFLAGS/d" common.sh
sed -i '/GUEST_IP/a\CFLAGS\="DSMALL"' common.sh
sed -i '/LOG_DIR/d' common.sh
sed -i '/CFLAGS/a\LOG_DIR=".\/log_S"' common.sh
./test.sh
sed -i "/CFLAGS/d" common.sh
sed -i '/GUEST_IP/a\CFLAGS\="DMIDDLE"' common.sh
sed -i '/LOG_DIR/d' common.sh
sed -i '/CFLAGS/a\LOG_DIR=".\/log_M"' common.sh
./test.sh
sed -i "/CFLAGS/d" common.sh
sed -i '/GUEST_IP/a\CFLAGS\="DLARGE"' common.sh
sed -i '/LOG_DIR/d' common.sh
sed -i '/CFLAGS/a\LOG_DIR=".\/log_L"' common.sh
./test.sh
 

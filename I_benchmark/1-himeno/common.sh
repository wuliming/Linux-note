#!/bin/bash
#
# Program:
#	himeno test configuration file
# History:
#	yangtao 2017/11/28 1.0v
#

TEST_MODE=1                   #TEST_MODE=0 native test; TEST_MODE=1 guest test
TEST_TIMES=1                  #Number of tests
TAZYU_NATIVE="1 2 4 8"
TAZYU_GUEST="1 2 4 8"
BIND_CPU="yes"                #Whether to bind the CPU
GUEST_IP="192.168.122.7"
CFLAGS="DLARGE"               #Test scale: SSMALL | SMALL | MIDDLE | LARGE | ELARGE
LOG_DIR="./log" 

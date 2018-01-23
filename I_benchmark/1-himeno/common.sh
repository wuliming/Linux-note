#!/bin/bash
#
# Program:
#	himeno test configuration file
# History:
#

TEST_MODE=0                   #TEST_MODE=0 native test; TEST_MODE=1 guest test
TEST_TIMES=1                  #Number of tests
#TAZYU_NATIVE="1 2 4 8"
TAZYU_NATIVE="1"
TAZYU_GUEST="1 2"
BIND_CPU="yes"                #Whether to bind the CPU
GUEST_IP="192.168.122.244"
CFLAGS="DLARGE"		      #DSSMALL DSMALL DMIDDLE DLARGE DELARGE"
LOG_DIR="./log"

# small : 33,33,65		3.78	MB
# small : 65,65,129		29.11	MB
# midium: 129,129,257		228.40	MB
# large : 257,257,513		1809.55	MB
# ext.large: 513,513,1025	14406.11MB


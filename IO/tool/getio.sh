#!/bin/sh

PARTION=$1

# get the block size
/sbin/tune2fs -l $PARTION | grep -i "Block size"


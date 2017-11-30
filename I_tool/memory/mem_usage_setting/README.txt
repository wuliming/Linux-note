version 1.01
./start_tunning.sh $mem%  $type  $usleep_time

1) $mem% :  set MEM usage
2) $type :
          a) 1: 4KB/time
          b) 2: 1MB/time
          c) 3: 1GB/time
3) usleep_time : sleep microsecond(us)
                 1000 us = 1m
                 1000000 = 1s

HOW TO:

1) # make clean

2) # make -B

3) Usage:

	a) ./start_tunning.sh 40       # set MEM usage to 40%
											 # If current MEM_USED is already MORE THAN
											   40% of MEM_TOTAL, then exit with nothing
												done.

	b) ./stop_tunning.sh           # stop MEM usage setting

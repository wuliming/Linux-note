HOW TO:

$1    cpu NO.
$2    cpu usage percent
$3    sleep time seconds

EXAMPLE:

	1) ./start_tunning.sh 1,3,5 60     # set 60% CPU usage for core 1,3,5
	2) ./start_tunning.sh 1 60 10     # set 60% CPU usage for core 1 for 10 seconds


1) # make clean

2) # make

3) Usage:

	a) ./start_tunning.sh all 70       # set 70% CPU usage for all cores

	b) ./start_tunning.sh 1,3,5 60     # set 60% CPU usage for core 1,3,5

	c) ./start_tunning.sh 3-5 40       # set 40% CPU usage for core 3,4,5

	d) ./start_tunning.sh 2,5,7-10 80  # set 80% CPU usage for core 2,5,7,8,9,10

	e) ./stop_tunning.sh               # stop CPU usage set of all cores

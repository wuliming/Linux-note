# git clone https://github.com/21cnbao/meltdown-example.git
# make
# insmod proc.ko
# lsmod |grep proc
# tail dmesg
# dmesg |grep variable

- sse instructions can increase performance of program
# gcc -O2 -msse2 meltdown-baohua.c
# ./a.out ffffffffa09b9000 4



native:
1.install
1). yum install libaio*
2). tar -jxvf fio-2.1.7.tar.bz2
3). cd fio-2.1.7/
4). ./configure
5). make clean
6). make
7). make install

2.change file
1).change the file : common.sh
  
# vi common.sh
ISGUEST=0                   #don't change
GUEST_IP=192.168.19.128     #don't change
TESTTIMES=3                 #need change

ISTASKSET=0                 #need change
DISK=(sdb sdc sdd sde)      #need change
FILESYSTEM=(blockio xfs ext3 ext4)            #need change
DISK_SIZE=2000MB            #need change

TAZYU=(1 2 4 8 16 32)       #need change
MODES=(read write randread randwrite)       #need change
IODEPTH=64                  #need change
SIZE=(512MB 1024MB)         #need change
DIRECT=1                    #need change
BS=(4KB 256K 512K)          #need change
NUMJOBS=1                   #need change  

IOENGINE=libaio             #don't change
FILENAME=ioTestr            #don't change
BENCHMARK_DIR="/home/Benchmark/Benchmarks_20160825/13-fio"  #don't change

3.run
# ./start_run.sh


guest:
1.install
1). yum install libaio*
2). tar -jxvf fio-2.1.7.tar.bz2
3). cd fio-2.1.7/
4). ./configure
5). make clean
6). make
7). make install

2.change file
1).change the file : common.sh

# vi common.sh
ISGUEST=1                   #need change
GUEST_IP=192.168.19.128     #need change
TESTTIMES=3                 #need change

ISTASKSET=0                 #need change
DISK=(sdb sdc sdd sde)      #need change
FILESYSTEM=(blockio xfs ext3 ext4)            #need change
DISK_SIZE=2000MB            #need change

TAZYU=(1 2 4 8 16 32)       #need change
MODES=(read write randread randwrite)       #need change
IODEPTH=64                  #need change
SIZE=(512MB 1024MB)         #need change         
DIRECT=1                    #need change
BS=(4KB 256K 512K)          #need change
NUMJOBS=1                   #need change

IOENGINE=libaio             #don't change
FILENAME=ioTestr            #don't change
BENCHMARK_DIR="/home/Benchmark/Benchmarks_20160825/13-fio"  #don't change

3.run
1).# ./start_run.sh

4.getdata
1)# cd /home/Benchmark/Benchmarks_20160825/13-fio
# ./ get_data.sh
# cat fio-result.csv
----------------tazyu 1 mode read bs 4KB size 512MB filesystem blockio---------------------
17833
----------------tazyu 1 mode read bs 256K size 512MB filesystem blockio---------------------
341.333
----------------tazyu 1 mode read bs 4KB size 1024MB filesystem blockio---------------------
......



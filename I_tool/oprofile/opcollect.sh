LOGFILE="/home/wulm/OProfile_LOG"
DURATION=10
echo "start OProfile ($DURATION s)"
echo "set up OProfile"

# Shut down daemon. Unload the oprofile module and oprofilefs.
opcontrol --deinit 2>> $LOGFILE

# current session effectiveness
modprobe oprofile timer=1  

opcontrol --setup --vmlinux=/usr/lib/debug/lib/modules/`uname -r`/vmlinux
#opcontrol --setup --event=l2_lines_in:500 --vmlinux=/usr/lib/debug/lib/modules/3.10.0-514.el7.x86_64/vmlinux

# Enable callgraph sample collection with a maximum depth. 
# Use 0 to  dis-able  callgraph profiling. 
#opcontrol -c 0

opcontrol --reset
echo "start OProfile" 
opcontrol --start >> $LOGFILE 2>&1
sleep $DURATION
#./test &
#opcontrol --dump
echo "shutdown OProfile"
opcontrol --shutdown >> $LOGFILE 2>&1

echo "report OProfile"
opreport -l > opreport_-l_1.txt 2>> $LOGFILE

echo "oprofile temp data size: $(du -sh /var/lib/oprofile)"
echo "cleanup OProfile"
opcontrol --reset
opcontrol --deinit 2>> $LOGFILE
echo "finish OProfile"

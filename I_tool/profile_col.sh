#!/bin/bash
export LANG=C
trap "opcontrol --shutdown > /dev/null 2>&1 ; kill $(jobs -p) > /dev/null 2>&1" EXIT

if [ $# -ne 1 ]; then
  echo "Usage: collect.sh <output dir>"
  exit 1
fi

if [ -e $1 ]; then
  echo "$1 already exists"
  exit 1
fi

OUTDIR=$1
LOGFILE=$OUTDIR/collect.log
DURATION=60
RHELVERSION=`cat /etc/redhat-release | sed -e "s/^.*\([0-9]\)\..*$/\1/" 2> /dev/null`
if [ x$RHELVERSION = "x6" ]
then
  NEED_PACKAGEDS="kernel-debuginfo kernel-debuginfo-common-x86_64 oprofile perf"
else
  NEED_PACKAGEDS="kernel-debuginfo kernel-debuginfo-common oprofile"
fi

function log_message() {
  echo "`date +'%H:%M:%S'`: $1" >> $LOGFILE
}

mkdir -p $OUTDIR

log_message "start: `date`"
log_message "RHEL version: $RHELVERSION"
log_message "checking packages ..."
for p in $NEED_PACKAGEDS
do
  rpm -q $p > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  Installed: $p" >> $LOGFILE
  else
    echo "  Error: $p is not installed"
    exit 1
  fi
done
log_message "checking packages ok."

echo "start OProfile ($DURATION s)"
log_message "set up OProfile"
opcontrol --deinit 2>> $LOGFILE
modprobe oprofile timer=1
opcontrol --setup --vmlinux=/usr/lib/debug/lib/modules/`uname -r`/vmlinux
opcontrol -c 0

opcontrol --reset
log_message "start OProfile"
opcontrol --start >> $LOGFILE 2>&1
sleep $DURATION
log_message "shutdown OProfile"
opcontrol --shutdown >> $LOGFILE 2>&1

log_message "report OProfile"
opreport -l > $OUTDIR/opreport_-l.txt 2>> $LOGFILE

log_message "oprofile temp data size: $(du -sh /var/lib/oprofile)"
log_message "cleanup OProfile"
opcontrol --reset
opcontrol --deinit 2>> $LOGFILE
echo "finish OProfile"

sleep 3

if [ $RHELVERSION = 6 ]; then
  echo "start perf ($DURATION s)"

  log_message "start perf"
  perf record -a 2>> $LOGFILE &

  sleep $DURATION

  log_message "stop perf"
  kill -SIGINT `jobs -p`

  sleep 5

  log_message "report perf"
  perf report > $OUTDIR/perf_report.txt 2>> $LOGFILE

  log_message "perf temp data size: $(du -sh perf.data)"
  test -f perf.data && rm -f perf.data
  echo "finish perf"
fi

log_message "done."



#!/bin/sh


set -x
# test using follow commad 
#systemd-run --scope --slice operation-groupb.slice ./bmt &


# limit value= ($1 * CORES)%
# example: 10Cores  -> 800% -> cpu usage 800% at the most
CORES=`lscpu | grep "^CPU(s):" | awk '{print $2}'`
LIMIT=$((CORES*$1))
if [[ ! -d /home/wulm/cgroup ]]; then
  mkdir -p /home/wulm/cgroup
fi
if [[ ! -f /home/wulm/cgroup/before_system.txt ]]; then
    ls -l /etc/systemd/system > /home/wulm/cgroup/before_system.txt
fi
if [[ ! -f /home/wulm/cgroup/before_cgls.txt ]]; then
    systemd-cgls -all > /home/wulm/cgroup/before_cgls.txt
fi
if [[ ! -f /home/wulm/cgroup/before_show.txt ]]; then
    systemctl show > /home/wulm/cgroup/before_show.txt
fi

# confirm whehter has slice.  should has
systemctl list-dependencies multi-user.target | grep slice

# confirm wheter has "system.slice.d" "user.slice.d". should has not
ls /etc/systemd/system | grep slice

# set cgroup
systemctl set-property system.slice CPUShares=10240
cat /etc/systemd/system/system.slice.d/50-CPUShares.conf
systemctl set-property user.slice CPUShares=10240
cat /etc/systemd/system/user.slice.d/50-CPUShares.conf

ls /etc/systemd/system | grep slice

#  edit operation.slice
cat>/etc/systemd/system/operation.slice<<EOF
[Unit]
Description=Operation Slice
DefaultDependencies=no
Before=slices.target
Wants=-.slice
After=-.slice
[Slice]
CPUShares=10240
[Install]
WantedBy=slices.target
EOF
# edit operation-groupa.slice
cat>/etc/systemd/system/operation-groupa.slice<<EOF
[Unit]
Description=group A Slice
DefaultDependencies=no
Before=slices.target
Wants=operation.slice
After=operation.slice
[Slice]
CPUShares=9216
[Install]
WantedBy=slices.target 
EOF
# edit operation-groupb.slice
# set limit 80% of cpu(CPUQuota=cores * 80%)
cat>/etc/systemd/system/operation-groupb.slice<<EOF
[Unit]
Description=group B Slice
DefaultDependencies=no
Before=slices.target
Wants=operation.slice
After=operation.slice
[Slice]
CPUShares=1024
CPUQuota=${LIMIT}%
[Install]
WantedBy=slices.target
EOF
# reload and restart and enable slice
systemctl list-unit-files --type=slice
systemctl daemon-reload
systemctl enable operation.slice operation-groupa.slice operation-groupb.slice
systemctl list-unit-files --type=slice
# systemctl reboot


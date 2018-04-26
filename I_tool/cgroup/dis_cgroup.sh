#!/bin/sh

set -x
systemctl list-unit-files --type=slice
systemctl disable operation.slice operation-groupa.slice operation-groupb.slice
systemctl list-unit-files --type=slice
rm -rf /etc/systemd/system/system.slice.d  /etc/systemd/system/user.slice.d
# reboot

#!/bin/sh

MODULES_DIR="/lib/modules/`uname -r`"

mod_status="`lsmod | grep sensor_power | awk '{print $1}'`"

if [ x"$mod_status" != x ]; then
	/usr/sbin/rmmod $MODULES_DIR/sensor_power.ko
fi

/usr/sbin/insmod $MODULES_DIR/sensor_power.ko

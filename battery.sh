#!/usr/bin/env sh

# adb shell acpi | awk '{ print $NF }'
adb shell dumpsys power | sed -n 's/.* mBatteryLevel=\(.*\)/\1/p'

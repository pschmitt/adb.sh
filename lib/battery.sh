#!/usr/bin/env sh

battery_level() {
    # adb shell acpi | awk '{ print $NF }'
    adb shell dumpsys power | sed -n 's/.* mBatteryLevel=\([0-9]\+\)/\1/p' | tr -dc '[[:print:]]'
}

is_charging() {
    adb shell dumpsys power | grep -q mIsPowered=true
}

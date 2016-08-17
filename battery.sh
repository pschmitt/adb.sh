#!/usr/bin/env sh

cd $(readlink -f $(dirname "$0"))

. lib/battery.sh

bat_lvl=$(battery_level)

if is_charging
then
    echo "${bat_lvl}+"
else
    echo "${bat_lvl}"
fi

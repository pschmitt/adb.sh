#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

# shellcheck disable=1091
source ./lib/battery.sh

bat_lvl=$(battery_level)

if is_charging
then
  echo "${bat_lvl}+"
else
  echo "${bat_lvl}"
fi

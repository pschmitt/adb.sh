#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

# shellcheck disable=1091
{
  source lib/screen.sh
  source lib/lockscreen.sh
}

usage() {
  echo "$(basename "$0") PIN"
}

if [[ "$#" -lt 1 ]]
then
  usage
  exit 2
fi

if screen_is_off
then
  unlock "$1"
else
  lock
fi


#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

# shellcheck disable=1091
{
  source lib/screen.sh
  source lib/lockscreen.sh
}

unlock "$1"

#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

# shellcheck=1091
source lib/screen.sh

if screen_is_off
then
  wake_screen
fi

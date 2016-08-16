#!/usr/bin/env sh

cd $(readlink -f $(dirname "$0"))

. lib/screen.sh
. lib/lockscreen.sh

lock

#!/usr/bin/env bash

cd $(readlink -f $(dirname "$0"))

. lib/screen.sh
. lib/lockscreen.sh

usage() {
    echo "$(basename $0) [PIN]"
}

unlock "$1"

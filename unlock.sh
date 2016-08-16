#!/usr/bin/env sh

cd $(readlink -f $(dirname "$0"))

. lib/screen.sh
. lib/lockscreen.sh

usage() {
    echo "$(basename $0) PIN"
}

if [[ $# -lt 1 ]]
then
    usage
    exit 2
fi

unlock "$1"

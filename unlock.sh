#!/usr/bin/env sh

usage() {
    echo "$(basename $0) PIN"
}

screen_is_on() {
    adb shell dumpsys input_method | grep -q mInteractive=true
}

swipe_up() {
    adb shell input swipe 200 900 200 300
}

enter_pin() {
    adb shell input text "$1"
    adb shell input keyevent ENTER
}

if [[ $# -lt 1 ]]
then
    usage
    exit 2
fi

if ! screen_is_on
then
    adb shell input keyevent POWER
fi
swipe_up
enter_pin "$1"

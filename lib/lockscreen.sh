#!/usr/bin/env sh

__swipe_up() {
    adb shell input swipe 200 900 200 300
}

__enter_pin() {
    adb shell input text "$1"
    adb shell input keyevent ENTER
}

unlock() {
    if [[ -z "$1" ]]
    then
        echo "No PIN provided" >&2
        exit 3
    fi
    wake_screen
    __swipe_up
    __enter_pin "$1"
}

lock() {
    screen_is_off || adb shell input keyevent POWER
}

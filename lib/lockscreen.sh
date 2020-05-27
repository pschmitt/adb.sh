#!/usr/bin/env bash

__swipe_up() {
    adb shell input swipe 200 900 200 300
}

__enter_pin() {
    adb shell input text "$1"
    adb shell input keyevent ENTER
}

unlock() {
    wake_screen
    __swipe_up
    if [[ -n "$1" ]]
    then
        __enter_pin "$1"
    fi
}

lock() {
    screen_is_off || adb shell input keyevent POWER
}

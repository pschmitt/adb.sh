#!/usr/bin/env sh

screen_is_on() {
    # adb shell dumpsys input_method | grep -q mInteractive=true
    adb shell dumpsys power | grep -q mWakefulness=Awake
}

screen_is_off() {
    # adb shell dumpsys input_method | grep -q mInteractive=false
    # return ! is_screen_on
    adb shell dumpsys power | grep -q mWakefulness=Asleep
}

wake_screen() {
    screen_is_on || adb shell input keyevent POWER
}

# debug() {
#     if is_screen_on
#     then
#         echo is_screen_on: true
#     else
#         echo is_screen_on: false
#     fi
#     if is_screen_off
#     then
#         echo is_screen_off: true
#     else
#         echo is_screen_off: false
#     fi
#
# }

# debug

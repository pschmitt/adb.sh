#!/usr/bin/env sh

screen_is_on() {
    adb shell dumpsys input_method | grep -q mInteractive=true
}

if screen_is_on
then
    adb shell input keyevent POWER
else
    echo "Screen already off"
fi

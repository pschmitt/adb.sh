# shellcheck shell=bash

screen_is_on() {
  # adb shell dumpsys input_method | grep -q mInteractive=true
  adb shell dumpsys power | grep -q mWakefulness=Awake
}

screen_is_off() {
  # adb shell dumpsys input_method | grep -q mInteractive=false
  if screen_is_on
  then
    return 1
  else
    return 0
  fi
  # return ! is_screen_on
  # adb shell dumpsys power | grep -q "mWakefulness=Asleep\|mWakefulness=Dozing"
}

wake_screen() {
  screen_is_on || adb shell input keyevent POWER
}

screen_off() {
  screen_is_off || adb shell input keyevent POWER
}

# vim: set ft=bash et ts=2 sw=2 :

#!/usr/bin/env bash

__swipe_up() {
  adb shell input swipe 200 900 200 300
}

__enter_pin() {
  adb shell input text "$1"
  adb shell input keyevent ENTER
}

unlock() {
  if ! is_locked
  then
    return
  fi

  wake_screen
  __swipe_up

  # We need to check again the lockscreen here since it may have been
  # already unlocked by swiping up
  if is_locked && [[ -n "$1" ]]
  then
    __enter_pin "$1"
  fi
}

lock() {
  screen_is_off || adb shell input keyevent POWER
}

is_locked() {
  adb shell dumpsys window | \
    sed -nr 's/.*mDreamingLockscreen=(true|false).*/\1/p' | \
      grep -q true
}


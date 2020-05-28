# shellcheck shell=bash

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
  send_key menu

  # We need to check again the lockscreen here since it may have been
  # already unlocked by swiping up
  # FIXME Detect if the lockscreen prompt is displayed
  if is_locked && [[ -n "$1" ]]
  then
    __enter_pin "$1"
  fi
}

lock() {
  screen_is_off || adb shell input keyevent POWER
}

is_locked() {
  adb shell su -c "dumpsys window" | \
    sed -nr 's/.*mDreamingLockscreen=(true|false).*/\1/p' | \
      grep -q true
}

is_unlocked() {
  if is_locked
  then
    return 1
  fi
}

# vim: set ft=bash et ts=2 sw=2 :

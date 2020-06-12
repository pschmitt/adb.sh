# shellcheck shell=bash

__enter_pin() {
  adb shell input text "${1:-$ANDROID_PIN}"
  adb shell input keyevent ENTER
}

is_lockscreen_displayed() {
  adb shell dumpsys power | grep -q 'mHoldingDisplaySuspendBlocker=true'
}

unlock() {
  if ! is_locked
  then
    return
  fi

  wake_screen
  send_key menu

  local pin="${1:-$ANDROID_PIN}"
  if is_lockscreen_displayed && [[ -n "$pin" ]]
  then
    __enter_pin "$pin"
  fi
}

lock() {
  screen_is_off || adb shell input keyevent POWER
}

is_locked() {
  adb shell su -c "dumpsys window" | \
    grep -q "mDreamingLockscreen=true"
}

is_unlocked() {
  if is_locked
  then
    return 1
  fi
}

# vim: set ft=bash et ts=2 sw=2 :

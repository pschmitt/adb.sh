# shellcheck shell=bash

wait_for_activity() {
  while ! adb shell dumpsys activity recents | grep "Recent #0" | grep -q -- "$@"
  do
    sleep 1
  done
}

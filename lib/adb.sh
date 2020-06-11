# shellcheck shell=bash

adb_devices() {
  adb devices | grep -v "List of devices" | sed '/^[[:space:]]*$/d'
}

wait_for_any_device() {
  while ! adb_devices | grep -q .
  do
    sleep 1
  done
}

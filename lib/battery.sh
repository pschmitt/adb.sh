#!/usr/bin/env bash

battery_level() {
  # adb shell acpi | awk '{ print $NF }'
  adb shell dumpsys power | \
    sed -n 's/.* mBatteryLevel=\([0-9]\+\)/\1/p' | \
    head -1
}

is_charging() {
  adb shell dumpsys power | grep -q mIsPowered=true
}

plug_type() {
  # https://developer.android.com/reference/android/os/BatteryManager.html#BATTERY_PLUGGED_AC
  local plug_type
  plug_type="$(adb shell dumpsys power | sed -n 's/.*mPlugType=\([0-9]\+\).*/\1/p')"

  case "$plug_type" in
    0)
      echo "Not charging" >&2
      return 1
      ;;
    1)
      echo ac
      ;;
    2)
      echo usb
      ;;
    4)
      echo wireless
      ;;
    *)
      echo "unknown ($plug_type)"
      ;;
  esac
}

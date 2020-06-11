# shellcheck shell=bash

toggle_setting() {
  local activity="$1"
  local setting="$2"

  unlock

  adb shell am force-stop com.android.settings
  # Send home in case the notifications bar is pulled down
  send_key home

  # Start settings activity
  if [[ -n "$activity" ]]
  then
    adb shell am start -a android.intent.action.MAIN \
      -n "com.android.settings/${activity}"
  else
    adb shell am start -a android.settings.SETTINGS
  fi

  wait_for_activity com.android.settings

  coords="$(get_screen_coords_of_text "$setting")"

  if [[ -z "$coords" ]]
  then
    echo "Toggling setting $setting failed" >&2
    return 1
  fi

  adb shell input tap "$coords"

  # Clean up
  wait_for_any_device
  adb shell am force-stop com.android.settings
}

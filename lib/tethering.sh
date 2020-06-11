# shellcheck shell=bash

toggle_usb_tethering() {
  local coords

  unlock

  adb shell am force-stop com.android.settings
  # Send home in case the notifications bar is pulled down
  send_key home
  adb shell am start -a android.intent.action.MAIN -n com.android.settings/.TetherSettings

  wait_for_activity com.android.settings

  coords="$(get_screen_coords_of_text "USB tethering")"

  if [[ -z "$coords" ]]
  then
    echo "Toggling USB tethering failed" >&2
    return 1
  fi
  adb shell input tap "$coords"

  # Clean up
  wait_for_any_device
  adb shell am force-stop com.android.settings
}

usb_tethering_is_on() {
  adb shell getprop sys.usb.config | grep -q rndis
}

enable_usb_tethering() {
  if usb_tethering_is_on
  then
    return
  fi
  toggle_usb_tethering
}

disable_usb_tethering() {
  if ! usb_tethering_is_on
  then
    return
  fi
  toggle_usb_tethering
}

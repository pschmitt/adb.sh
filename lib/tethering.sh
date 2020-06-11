# shellcheck shell=bash

toggle_usb_tethering() {
  toggle_setting .TetherSettings "USB tethering"
}

toggle_bluetooth_tethering() {
  toggle_setting .TetherSettings "Bluetooth tethering"
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

# shellcheck shell=bash

screenshot() {
  # adb shell screencap -p | sed 's/\r$//' > "$1"
  # adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > "$2"

  # adb shell screencap -p /sdcard/screen.png
  # adb pull /sdcard/screen.png "$1"
  # adb shell rm /sdcard/screen.png

  adb exec-out screencap -p > "$1"
}

# vim: set ft=bash et ts=2 sw=2 :

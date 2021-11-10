# shellcheck shell=bash

screen_is_on() {
  # adb shell dumpsys input_method | grep -q mInteractive=true
  adb shell dumpsys power | grep -q mWakefulness=Awake
}

screen_is_off() {
  # adb shell dumpsys input_method | grep -q mInteractive=false
  if screen_is_on
  then
    return 1
  else
    return 0
  fi
  # return ! is_screen_on
  # adb shell dumpsys power | grep -q "mWakefulness=Asleep\|mWakefulness=Dozing"
}

wake_screen() {
  screen_is_on || adb shell input keyevent POWER
}

screen_off() {
  screen_is_off || adb shell input keyevent POWER
}

screen_get_autoration() {
  [[ "$(adb shell settings get system accelerometer_rotation)" == 1 ]]
}

screen_set_autorotation() {
  local val=1

  case "$1" in
    off|disable|0)
      val=0
      ;;
  esac

  adb shell settings put system accelerometer_rotation "$val"
}

# https://stackoverflow.com/q/25864385/1872036
screen_enable_autorotation() {
  screen_set_autorotation on
}

screen_disable_autorotation() {
  screen_set_autorotation off
}

screen_set_orientation() {
  adb shell settings put system user_rotation "$1"
}

# https://stackoverflow.com/a/14218131/1872036
screen_rotation_status() {
  local res orientation

  res="$(adb shell dumpsys input | awk '/SurfaceOrientation/ { print $2 }')"

  case "$res" in
    0)
      orientation=portrait
      ;;
    1)
      orientation=landscape
      ;;
    2)
      orientation=portrait-inverted
      ;;
    3)
      orientation=landscape-inverted
      ;;
    *)
      echo "Unknown screen rotation value: $res" >&2
      return 1
      ;;
  esac

  echo "$orientation"
}

screen_rotate() {
  local orientation="${1:-auto}"

  if [[ "$orientation" == "auto" ]]
  then
    screen_enable_autorotation
    return "$?"
  fi

  local action
  case "$orientation" in
    noauto|no-auto|no|false|disable|off)
      screen_disable_autorotation
      return
      ;;
    portrait|port|narrow|0)
      action=portrait
      ;;
    landscape|land|la|wide|1|90)
      action=landscape
      ;;
    portrait2|portrait-inv|portrait-inverted|180)
      action=portrait-inverted
      ;;
    landscape2|landscape-inverted|landscape-inv|land2|la2|l2|wide2|270)
      action=landscape-inverted
      ;;
    *)
      echo "Unknown orientation: $orientation" >&2
      return 2
      ;;
  esac

  screen_disable_autorotation

  # 0: Portrait
  # 1: Landscape
  # 2: Portrait - inverted (180)
  # 3: Landscape Reversed (270)

  case "$action" in
    portrait)
      screen_set_orientation 0
      ;;
    landscape)
      screen_set_orientation 1
      ;;
    portrait-inverted)
      screen_set_orientation 2
      ;;
    landscape-inverted)
      screen_set_orientation 3
      ;;
  esac
}

# vim: set ft=bash et ts=2 sw=2 :

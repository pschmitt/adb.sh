# shellcheck shell=bash

send_key() {
  local key="$1"

  if [[ -z "$key" ]]
  then
    echo "Missing key parameter" >&2
    return 2
  fi

  case "$key" in
    home)
      key=3
      ;;
    up)
      key=19
      ;;
    down)
      key=20
      ;;
    left)
      key=21
      ;;
    right)
      key=22
      ;;
    enter)
      key=66
      ;;
    vol_up)
      key=24
      ;;
    vol_down)
      key=25
      ;;
    paste)
      key=279
      ;;
  esac

  adb shell input keyevent "$key"
}

# vim: set ft=bash et ts=2 sw=2 :

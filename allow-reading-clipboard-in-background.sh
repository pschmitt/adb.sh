#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename "$0") APP_OR_PKG"
  echo "Supported apps: Join (join)"
  # echo "Supported apps: Termux::API (termux) and Join (join)"
}

allow() {
  local pkg_name="$1"

  # https://joaoapps.com/AutoApps/Help/Info/com.joaomgcd.join/android_10_read_logs.html

  adb shell appops set "${pkg_name}" SYSTEM_ALERT_WINDOW allow
  adb shell pm grant "${pkg_name}" android.permission.WRITE_SECURE_SETTINGS
  adb shell pm grant "${pkg_name}" android.permission.READ_LOGS
  adb shell am force-stop "${pkg_name}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  case "$1" in
    help|h|-h|--help)
      usage
      exit 0
      ;;
    join)
      PKG_NAME=com.joaomgcd.join
      ;;
    # FIXME This does not work for Termux::API since it does not request the
    # WRITE_SECURE_SETTINGS permission
    # https://github.com/termux/termux-api/issues/211
    #
    # termux)
    #   PKG_NAME=com.termux.api
    #   ;;
    *)
      usage
      exit 2
      ;;
  esac

  allow "$PKG_NAME"
fi

# vim: set ft=bash et ts=2 sw=2 :

#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

usage() {
  echo "Usage: $(basename "$0") ACTION [PARAMS]"
  echo "Available actions:"
  echo "- app"
  echo "- battery"
  echo "- charging"
  echo "- key"
  echo "- lock"
  echo "- screen"
  echo "- screenshot"
  echo "- toggle-lock"
  echo "- unlock"
  echo "- wake"
}

# Import all the stuff from lib
for f in lib/*
do
  # shellcheck disable=1090
  source "$f"
done
unset f

case "$1" in
  help|--help|-h)
    usage
    exit 0
    ;;
  lock)
    lock
    ;;
  unlock)
    unlock "$2"
    ;;
  toggle-lock)
    if is_locked
    then
      unlock "$2"
    else
      lock
    fi
    ;;
  wake)
    wake_screen
    ;;
  screen|display)
    case "$2" in
      on)
        wake_screen
        ;;
      off)
        screen_off
        ;;
      *)
        screen_is_on && echo "on" || echo "off"
        ;;
    esac
    ;;
  screenshot)
    DEST=${2:-screenshot.jpg}
    echo "Capturing screenshot and saving it to $DEST"
    screenshot "$DEST"
    ;;
  battery)
    battery_level
    ;;
  charging)
    plug_type
    ;;
  app)
    if [[ $# -lt 2 ]]
    then
      echo "Usage: list|start|stop|restart PACKAGE" >&2
      exit 2
    fi
    case "$2" in
      start)
        start_app "$3"
        ;;
      restart)
        restart_app "$3"
        ;;
      stop)
        stop_app "$3"
        ;;
      list)
        list_packages
        ;;
      *)
        echo "Unknown command. Use start|stop|restart|list" >&2
        exit 2
        ;;
    esac
    ;;
  key)
    if [[ $# -lt 2 ]]
    then
      echo "Usage: key KEYEVENT" >&2
      exit 2
    fi
    case "$2" in
      home)
        keyevent=3
        ;;
      up)
        keyevent=19
        ;;
      down)
        keyevent=20
        ;;
      left)
        keyevent=21
        ;;
      right)
        keyevent=22
        ;;
      enter)
        keyevent=66
        ;;
      vol_up)
        keyevent=24
        ;;
      vol_down)
        keyevent=25
        ;;
      paste)
        keyevent=279
        ;;
      *)
        keyevent="$2"
        ;;
    esac
    adb shell input keyevent "$keyevent"
    ;;
  scan|discover)
    shift
    adbd_discover "$@"
    ;;
  exec)
    shift
    "$@"
    ;;
  *)
    if command -v "$1" >/dev/null
    then
      "$@"
    else
      echo "Unknown command or function: $1" >&2
      usage
      exit 2
    fi
    ;;
esac

# vim: set ft=bash et ts=2 sw=2 :

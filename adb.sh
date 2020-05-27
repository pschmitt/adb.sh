#!/usr/bin/env bash

cd $(readlink -f $(dirname "$0"))

# Import all the stuff from lib
for f in lib/*
do
    . "$f"
done
unset f

case "$1" in
    lock)
        lock
        ;;
    unlock)
        unlock "$2"
        ;;
    wake)
        wake_screen
        ;;
    screen)
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
        echo "Capture screenshot and safe it to $DEST"
        screenshot "$DEST"
        ;;
    battery)
        battery_level
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
                keyevent=3 ;;
            up)
                keyevent=19 ;;
            down)
                keyevent=20 ;;
            left)
                keyevent=21 ;;
            right)
                keyevent=22 ;;
            enter)
                keyevent=66 ;;
            vol_up)
                keyevent=24 ;;
            vol_down)
                keyevent=25 ;;
            paste)
                keyevent=279 ;;
            *)
                keyevent="$2" ;;
        esac
        adb shell input keyevent "$keyevent"
        ;;
    *)
        echo "Unknown command" >&2
        exit 2
        ;;
esac

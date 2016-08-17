#!/usr/bin/env sh

cd $(readlink -f $(dirname "$0"))

# Import all the stuff from lib
for f in lib/*
do
    . $f
done

case "$1" in
    lock)
        lock
        ;;
    unlock)
        if [[ -z "$2" ]]
        then
            echo "Missing PIN" >&2
            exit 2
        fi
        unlock "$2"
        ;;
    wake)
        wake_screen
        ;;
    battery)
        battery_level
        ;;
    app)
        if [[ $# -lt 3 ]]
        then
            echo "Usage: start|stop|restart PACKAGE" >&2
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
    *)
        echo "Unknown command" >&2
        exit 2
        ;;
esac

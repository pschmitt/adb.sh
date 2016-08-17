#!/usr/bin/env sh

get_app_name_from_apk() {
    # Usage: get_app_name_from_apk APK
    # eg: get_app_name_from_apk /data/app/com.nianticlabs.pokemongo-2/base.apk
    adb shell aapt dump badging "$1" | sed -n "s/application-label:'\(.*\)'/\1/p"
}

get_app_name() {
    # Usage: get_app_name PACKAGE
    # eg: get_app_name com.nianticlabs.pokemongo
    local apk=$(get_apk_location "$1")
    get_app_name_from_apk "$apk"
}

get_apk_location() {
    # Usage: get_apk_location PACKAGE
    # eg: get_apk_location com.pushbullet.android
    adb shell pm list packages -f "$1" | sed -n 's/package:\(.*\)=.*/\1/p'
}

list_packages() {
    adb shell pm list packages | sed -n 's/package:\(.*\)/\1/p' | sort
}

get_app_package() {
    # Usage: get_app_package APP
    # eg: get_app_package "Pokémon GO"
    echo "Not implemented yet" 2>&1
}

get_main_activity() {
    # Usage: get_main_activity PACKAGE
    # eg: get_main_activity com.nianticlabs.pokemongo
    adb shell pm dump "$1" | grep -A1 -m 1 MAIN | awk 'END { print $2 }' | tr -dc '[[:print:]]'
}

stop_app() {
    # echo "Not implemented yet" 2>&1
    adb shell am force-stop "$1"
}

start_app() {
    # echo "Not implemented yet" 2>&1
    local activity=$(get_main_activity "$1")
    echo "START THIS XX${activity}XX"
    adb shell am start "$activity"
}

restart_app() {
    stop_app "$1"
    start_app "$1"
}

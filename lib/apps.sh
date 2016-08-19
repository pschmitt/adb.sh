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

__known_packages() {
    case "$1" in
        "Pokémon GO"|"pokemon")
            echo "com.nianticlabs.pokemongo"
            ;;
        "PushBullet"|"pb")
            echo "com.pushbullet.android"
            ;;
        *)
            # echo "Unknown app" >&2
            echo
            ;;
    esac
}

__is_known_app() {
    [[ -n $(known_packages "$1") ]]
}

__is_a_package_name() {
    grep -q \\. <<< "$1"
}

__guess_package_name() {
    if __is_a_package_name "$1"
    then
        echo "$1"
    else
        __known_packages "$1"
    fi
}

get_main_activity() {
    # Usage: get_main_activity PACKAGE
    # eg: get_main_activity com.nianticlabs.pokemongo
    adb shell pm dump "$1" | grep -A1 -m 1 MAIN | awk 'END { print $2 }' | tr -dc '[[:print:]]'
}

current_activity() {
    adb shell dumpsys window windows | sed -n 's/.*mCurrentFocus=.*{\(.*\)}/\1/p' | awk '{ print $NF }'
}

stop_app() {
    # echo "Not implemented yet" 2>&1
    local pkg=$(__guess_package_name "$1")
    adb shell am force-stop "$pkg"
}

start_app() {
    # echo "Not implemented yet" 2>&1
    local pkg=$(__guess_package_name "$1")
    local activity=$(get_main_activity "$pkg")
    adb shell am start "$activity"
}

restart_app() {
    stop_app "$1"
    start_app "$1"
}

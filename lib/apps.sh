# shellcheck shell=bash

get_app_name_from_apk() {
  # Usage: get_app_name_from_apk APK
  # eg: get_app_name_from_apk /data/app/com.nianticlabs.pokemongo-2/base.apk

  # FIXME This does not work for some apps...
  # Like twitter for eg (com.twitter.android)
  local apk_path="$1"
  local output

  if adb shell command -v aapt > /dev/null
  then
    output="$(adb shell "aapt dump badging $apk_path")"
  else
    local aapt=/data/data/com.termux/files/usr/bin/aapt
    output="$(adb shell su -c "$aapt dump badging $apk_path")"
  fi
  sed -nr "s/.*label='([^']+)'.*/\1/p" <<< "$output" | head -1
}

get_app_name() {
  # Usage: get_app_name PACKAGE
  # eg: get_app_name com.nianticlabs.pokemongo
  local apk
  apk=$(get_apk_location "$1")
  get_app_name_from_apk "$apk"
}

get_apk_location() {
  # Usage: get_apk_location PACKAGE
  # eg: get_apk_location com.pushbullet.android
  local pkg_name="$1"
  local apk_path
  local -a apk_paths

  while read -r apk_path
  do
    apk_paths+=("$apk_path")
  done < <(adb shell pm list packages -f "$pkg_name" | \
            sed -n 's/package:\(.*\)=.*/\1/p')

  if [[ "${#apk_paths[@]}" == "1" ]]
  then
    echo "${apk_paths[0]}"
    return
  fi

  # Search for best match
  # At this point we have the following:
  #
  # pkg_name=com.termux
  # apk_paths=(
  #   /data/app/com.termux.api-FM0eQoDhHfgIomeaBC-TGA==/base.apk
  #   /data/app/com.termux.tasker-Bj6KoFI4SXRFTZyYszpJ1g==/base.apk
  #   /data/app/com.termux-5Nmgmxo_Wz3GLx27JvS34Q==/base.apk
  # )
  #
  # So we need to get rid of com.termux.api and com.termux.tasker here

  for apk_path in "${apk_paths[@]}"
  do
    # Filter out submatches
    if grep -q "${pkg_name}\." <<< "$apk_path"
    then
      continue
    fi
    echo "$apk_path"
    return
  done
}

get_app_label_from_package_name() {
  local apk_path
  apk_path="$(get_apk_location "$1")"

  aapt dump badging "$apk_path" | sed -nr "s/.*label='([^']+)'.*/\1/p" | head -1
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
    "IPwebcam"|"cam")
      echo "com.pas.webcam.pro"
      ;;
    "Kodi"|"kodi"|"xbmc")
      echo "org.xbmc.kodi"
      ;;
    "Deckboard"|"deckboard"|"bdoard")
      echo "com.rivafarabi.deckboard.pro"
      ;;
    *)
      echo "Unknown app" >&2
      return 2
      echo
      ;;
  esac
}

__is_known_app() {
  [[ -n $(known_packages "$1" 2>/dev/null) ]]
}

__is_a_package_name() {
  grep -q \\. <<< "$1"
}

__guess_package_name() {
  local pkg_name
  pkg_name="$(__known_packages "$1" 2>/dev/null)"

  if [[ -n "$pkg_name" ]]
  then
    echo "$pkg_name"
  else
    # Return first matching name
    list_packages | grep -i -m 1 "$1"
  fi
}

get_main_activity() {
  # Usage: get_main_activity PACKAGE
  # eg: get_main_activity com.nianticlabs.pokemongo
  case "$1" in
    org.xbmc.kodi)
      echo "org.xbmc.kodi/.Splash"
      ;;
    *)
      adb shell pm dump "$1" | grep -A1 -m 1 MAIN | \
        awk 'END { print $2 }' | tr -dc '[:print:]'
      ;;
  esac
}

current_activity() {
  adb shell su -c "dumpsys window windows" | \
    sed -n 's/.*mCurrentFocus=.*{\(.*\)}/\1/p' | awk '{ print $NF }'
}

stop_app() {
  local pkg
  pkg=$(__guess_package_name "$1")
  adb shell am force-stop "$pkg"
}

start_app() {
  local activity
  local pkg

  pkg=$(__guess_package_name "$1")
  activity=$(get_main_activity "$pkg")

  adb shell am start "$activity"
}

restart_app() {
  stop_app "$1"
  start_app "$1"
}

# vim: set ft=bash et ts=2 sw=2 :

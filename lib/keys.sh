# shellcheck shell=bash

send_key() {
  local key="$1"

  if [[ -z "$key" ]]
  then
    echo "Missing key parameter" >&2
    return 2
  fi

  # https://developer.android.com/reference/android/view/KeyEvent
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
    menu)
      key=82
      ;;
    backspace)
      key=KEYCODE_DEL
      ;;
    delete)
      key=KEYCODE_FORWARD_DEL
      ;;
    '(')
      key=KEYCODE_NUMPAD_LEFT_PAREN
      ;;
    ')')
      key=KEYCODE_NUMPAD_RIGHT_PAREN
      ;;
    *)
      key="KEYCODE_${key^^}"
      ;;
  esac

  adb shell input keyevent "$key"
}

send_text() {
  local text

  if [[ -n "$*" ]]
  then
    text="$*"
  else
    text="$(</dev/stdin)"
  fi

  echo "Writing text '$text' on the device" >&2
  adb shell input text "'$text'"
}

teletype() {
  # https://stackoverflow.com/a/56200043/1872036
  local key og_key
  local k1 k2 k3

  # shellcheck disable=2162
  while read -rsn1 key
  do
    og_key="$key"
    read -rsn1 -t 0.0001 k1 # This grabs all three symbols
    read -rsn1 -t 0.0001 k2 # and puts them together
    read -rsn1 -t 0.0001 k3 # so you can case their entire input.
    key+="${k1}${k2}${k3}"

    # DEBUG
    cat -v <<< "cat -v: KEY=$key OG_KEY=$og_key"

    case "$key" in
      $'\e[D'|$'\e0D')
        key="left"
        ;;
      $'\e[C'|$'\e0C')
        key="right"
        ;;
      $'\e[B'|$'\e0B')
        key="down"
        ;;
      $'\e[A'|$'\e0A'|$'\e[D'|$'\e0D')
        key="up"
        ;;
      $'\177')
        key="backspace"
        ;;
      $'\e[3~')
        key="delete"
        ;;
      $'\E')
        key="escape"
        ;;
      ':')
        key="semicolon"
        ;;
      '.')
        key="numpad_dot"
        ;;
      # FIXME How can we differenciate between ENTER and SPACE?
      # $'\x0a')
      #   key=enter
      #   ;;
      ' ')
        key="space"
        ;;
      '')
        key="enter"
        ;;
    esac

    # DEBUG
    printf "Sending key: %s\n" "$key"
    send_key "$key"
    unset key
    printf "Ready for new input: \n"
  done
}

# vim: set ft=bash et ts=2 sw=2 :

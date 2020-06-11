# shellcheck shell=bash

get_screen_coords_of_text() {
  local cx1 cy1 cx2 cy2
  local dump
  local text="$1"
  local tmpdump

  dump=$(adb shell uiautomator dump | sed -rn 's/.*dumped to: (.+)/\1/p')
  tmpdump="$(mktemp)"
  adb pull "$dump" "$tmpdump" >&2
  # Clean up
  adb shell rm -f "$dump" >&2

  # https://stackoverflow.com/a/50027374/1872036
  read -r cx1 cy1 cx2 cy2 <<< \
    "$(sed -nr 's/.*'"${text}"'[^>]+bounds="\[([0-9]+),([0-9]+)\]\[([0-9]+),([0-9]+)\]".*/\1 \2 \3 \4/p' "$tmpdump")"

  # Clean up
  rm -f "$tmpdump"

  if [[ -z "$cx1" ]]
  then
    echo "Failed to determine coordinates of $text" >&2
    return 1
  fi

  # Result
  echo "$(( (cx1 + cx2) / 2 )) $(( (cy1 + cy2) / 2 ))"
}

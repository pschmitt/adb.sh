#compdef adb.sh ads

_adb.sh() {
  _arguments -C \
    '1: :->command'\
    '*: :->argument' && ret=0
  case "$state" in
    command)
      local -a actions=(
        "lock:Lock screen"
        "unlock:Unlock screen"
        "toggle-lock:Toggle lockscreen state"
        "wake:Wake screen"
        "screen:Set screen state"
        "screenshot:Take a screenshot"
        "app:Start/Stop or list apps (package names)"
        "battery:Query battery level"
        "charging:Get charging state"
        "key:Send key input"
        "exec:Execute arbitrary command from library"
      )

      _describe -t commands "adb.sh commands" actions -V1
      ;;
    argument)
      case $words[2] in
        help)
          _message "Display help message" && ret=0
          ;;
        key)
          local -a actions=(
            "home:HOME"
            "up:UP arrow"
            "down:DOWN arrow"
            "left:LEFT arrow"
            "right:RIGHT arrow"
            "vol_up:VOLUME_UP"
            "vol_down:VOLUME_DOWN"
            "paste:PASTE"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        screen)
          local -a actions=(
            "on:Turn screen on"
            "off:Turn screen off"
            "state:Show current screen state (on|off)"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        app)
          if [[ "$#words" == "3" ]]
          then
            local -a actions=(
              "list:List package names"
              "start:Start an app"
              "stop:Stop an app"
              "restart:Restart an app"
            )
            _describe -t commands "adb.sh commands" actions -V1
          elif [[ "$#words" == "4" ]]
          then
            case "$words[3]" in
              start|stop|restart)
                local -a apps=()
                adb.sh app list -s | while read -r line
                do
                  apps+=(${line}\:"${line}")
                done
                _describe -t commands "adb.sh commands" apps -V1
                ;;
            esac
          fi
          ;;
      esac
      ;;
  esac
}

_adb.sh "$@"

# vim: set ft=zsh et ts=2 sw=2 :

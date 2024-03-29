#compdef adb.sh ads

_adb.sh() {

  _arguments -C \
    '1: :->command'\
    '*: :->argument'

  case "$state" in
    command)
      local -a actions=(
        "app:Start/Stop, show current or list all apps (package names)"
        "battery:Query battery level"
        "charging:Get charging state"
        "click:Click/tap on text"
        "exec:Execute arbitrary command from library"
        "key:Send key input"
        "lock:Lock screen"
        "replace-text:Replace current field content with text"
        "autorotation:Control auto rotation settings"
        "rotate:Rotate the screen"
        "scan:Scan the network for listening ADB daemons"
        "screen:Set screen state"
        "screenshot:Take a screenshot"
        "type:Type on your device"
        "text:Write text on your device. Either via pipe or direct input"
        "toggle-lock:Toggle lockscreen state"
        "unlock:Unlock screen"
        "usb-tethering:USB tethering"
        "wake:Wake screen"
      )

      _describe -t commands "adb.sh commands" actions -V1
      ;;
    argument)
      case $words[2] in
        help)
          _message "Display help message"
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
            "menu:MENU"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        autorotation)
          local -a actions=(
            "on:Enable screen autorotation"
            "off:Disable screen autorotation"
            "status:Get current screen autorotation status (on or off)"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        rotate)
          local -a actions=(
            "status:Get current screen rotation state (landscape, portrait etc)"
            "auto:Turn on auto screen rotation"
            "disable:Disable auto screen rotation"
            "landscape:Lanscape mode"
            "portrait:Portrait mode"
            "landscape-inverted:Inverted landscape mode"
            "portrait-inverted:Inverted portrait mode"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        screen|display)
          local -a actions=(
            "on:Turn screen on"
            "off:Turn screen off"
            "rotate:Rotate screen"
            "status:Show current screen state (on|off)"
          )
          if [[ "$#words" == "3" ]]
          then
            _describe -t commands "adb.sh commands" actions -V1
          fi
          ;;
        usb-tethering|usbt)
          local -a actions=(
            "on:Turn USB tethering on"
            "off:Turn USB tethering off"
            "state:Show current USB tethering state (on|off)"
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
              "current:Show current app package name"
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

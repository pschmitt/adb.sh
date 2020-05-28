# shellcheck shell=bash

swipe_up() {
  adb shell input swipe 200 900 200 300
}

# vim: set ft=bash et ts=2 sw=2 :

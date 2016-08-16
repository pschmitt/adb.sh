#!/usr/bin/env sh

adb shell acpi | awk '{ print $NF }'

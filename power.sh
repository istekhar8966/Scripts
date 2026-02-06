#!/bin/bash

choice=$(printf "Shutdown\nReboot" | dmenu -i -p "Power Menu:")

case "$choice" in
Shutdown) systemctl poweroff ;;
Reboot) systemctl reboot ;;
esac

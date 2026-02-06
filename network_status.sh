#!/usr/bin/env bash

# Use Nerd Font icons
ICON_WIFI="󰤨"
ICON_ETHERNET="󰍹"
ICON_DISCONNECTED="󰤮"

get_network_status() {
  ACTIVE_DEV=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

  if [ -z "$ACTIVE_DEV" ]; then
    echo "$ICON_DISCONNECTED Disconnected"
    return
  fi

  INFO=$(nmcli -t -f DEVICE,TYPE,CONNECTION dev | grep "^$ACTIVE_DEV" | head -n1)

  TYPE=$(echo "$INFO" | cut -d: -f2)
  NAME=$(echo "$INFO" | cut -d: -f3)

  case "$TYPE" in
  wifi)
    echo "$ICON_WIFI $NAME"
    ;;
  ethernet)
    echo "$ICON_ETHERNET Ethernet"
    ;;
  *)
    echo "$ICON_ETHERNET $NAME"
    ;;
  esac
}

get_network_status

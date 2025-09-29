#!/usr/bin/env bash
# Show active internet device only

get_network_status() {
    # Get device which is actually used for internet
    DEFAULT_DEV=$(ip route | grep '^default' | head -1 | awk '{print $5}')

    if [ -z "$DEFAULT_DEV" ]; then
        echo "󰤮 Disconnected"
        return
    fi

    # Get device type
    TYPE=$(networkctl status "$DEFAULT_DEV" 2>/dev/null | awk '/Type/ {print $2}')

    case "$TYPE" in
        ether)
            echo "󰈀 Ethernet"
            ;;
        wlan)
            echo "󰤨 Wi-Fi"
            ;;
        *)
            echo "󰈀 Connected"
            ;;
    esac
}

get_network_status


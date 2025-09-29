#!/bin/bash

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    echo "󰝟 Mute"
else
    echo "  ${vol}%"
fi


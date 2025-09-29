#!/bin/env bash
# ~/dwmblocks/nightlight.sh

# PID फ़ाइल का पथ
PIDFILE="/tmp/redshift.pid"

if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "🌙 On"
else
    echo "🌙 Off"
fi


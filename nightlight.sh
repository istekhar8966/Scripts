#!/bin/env bash
# ~/scripts/nightlight.sh

# PID फ़ाइल का पथ
PIDFILE="/tmp/redshift.pid"

if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    # redshift चल रहा है → बंद करें
    kill $(cat "$PIDFILE")
    rm -f "$PIDFILE"
    echo "🌙 Off"
else
    # redshift नहीं चल रहा है → चालू करें
    redshift -O 4000 &
    echo $! > "$PIDFILE"
    echo "🌙 On"
fi


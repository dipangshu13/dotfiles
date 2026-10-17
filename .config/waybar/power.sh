#!/bin/bash
PIDFILE="/tmp/waybar_shutdown.pid"
if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm -f "$PIDFILE"
    notify-send -a "System" "Shutdown Cancelled"
    exit 0
fi
notify-send -a "System"	 "Shutting down" "Click the power button again to CANCEL."
( sleep 3 && systemctl poweroff ) &
echo $! > "$PIDFILE"

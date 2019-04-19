#!/bin/bash

# delay required, otherwise it gives wrong values
sleep 0.25
if amixer get Master | grep "\[on\]"; then
    notify-send "Unmuted" -t 200
else
    notify-send "Muted" -t 200
fi

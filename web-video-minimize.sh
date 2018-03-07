#!/bin/bash
# global function to pause a running Youtube in Conkeror
# TODO: add for other browsers
# get current window
# TODO: actually time this and find something that goes faster, takes about 2-3s? but at least it minimizes first
# TODO: case sensitive/insensitive search
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# TODO minimize all windows first
# filtering by name probably cuts out more windows more quickly than class
xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep "${line}" >/dev/null; then
        xdotool windowminimize "${line}"
    fi
done
# filtering by class in this case really limits it to what is up,
# probably won't have multiple windows of these classes
xdotool search --class "Fceux|mGBA|PCSXR|PPSSPPSDL|zsnes" | while IFS= read -r line; do
    # now go through rest of potential websites
    # TODO: eventually just flip them off without muting
    # TODO: eventually have restore for all of these
    xdotool windowminimize "${line}"
    amixer set Master mute
done

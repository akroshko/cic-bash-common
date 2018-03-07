#!/bin/bash
# global function to restore a running Youtube in Conkeror
CURRENTWINDOW=$(xdotool getwindowfocus)
# filtering by name probably cuts out more windows more quickly than class
xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}"
        xdotool windowactivate --sync "${line}"
    fi
done
# filtering by name probably cuts out more windows more quickly than class
xdotool search --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        xdotool windowactivate --sync "${line}"
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f web-video-play
    fi
done
# restore focus
xdotool windowactivate --sync ${CURRENTWINDOW}

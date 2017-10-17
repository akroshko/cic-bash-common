#!/bin/bash
# global function to restore a running Youtube in Conkeror
CURRENTWINDOW=$(xdotool getwindowfocus)
xdotool search --onlyvisible --name youtube | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}"
        xdotool windowactivate --sync "${line}"
    fi
done
xdotool search --name youtube | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        xdotool windowactivate --sync "${line}"
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f youtube-play
    fi
done
# restore focus
xdotool windowactivate --sync ${CURRENTWINDOW}

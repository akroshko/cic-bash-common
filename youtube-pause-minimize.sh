#!/bin/bash
# global function to pause a running Youtube in Conkeror
# get current window
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
xdotool search --onlyvisible --name youtube | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowminimize "${line}"
    fi
done
# turn off youtube
xdotool search --name youtube | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f youtube-pause
        if [[ "${line}" == "${CURRENTWINDOW}" ]]; then
            CURRENTYOUTUBE=1
        fi
    fi
done
# restore focus if not youtube window
if [[ -n "$CURRENTYOUTUBE" ]]; then
    xdotool windowactivate --sync ${CURRENTWINDOW}
fi

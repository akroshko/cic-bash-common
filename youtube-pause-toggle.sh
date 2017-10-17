#!/bin/bash
# global function to pause a running Youtube in Conkeror
# get current window
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# turn off youtube
xdotool search --name youtube | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f youtube-pause-toggle
        if [[ "${line}" == "${CURRENTWINDOW}" ]]; then
            CURRENTYOUTUBE=1
        fi
    fi
done
xdotool windowactivate --sync ${CURRENTWINDOW}
# TODO: should have an if before xdotool, but couldn't get it working in 5 minutes
# restore focus if not youtube window
# if [[ -n "$CURRENTYOUTUBE" ]]; then
# fi

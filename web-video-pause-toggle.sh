#!/bin/bash
# global function to pause a running Youtube in Conkeror
# get current window
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# filtering by name probably cuts out more windows more quickly than class
xdotool search --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f web-video-pause-toggle
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

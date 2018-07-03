#!/bin/bash
# global function to minimize without pausing running videos or other media
# TODO: add for other browsers
# get current window
# TODO: actually time this and find something that goes faster, takes about 2-3s? but at least it minimizes first
# TODO: case sensitive/insensitive search
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# TODO minimize all windows first
# filtering by name probably cuts out more windows more quickly than class
# TODO: need global regex for this
xdotool search --onlyvisible --name "facebook|instagram|pixiv|twitter|twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "${line}" >/dev/null; then
        xdotool windowminimize "${line}"
    fi
done
# filtering by class in this case really limits it to what is up,
xdotool search --class "Fceux|mGBA|PCSXR|PPSSPPSDL|zsnes|dolphin-emu" | while IFS= read -r line; do
    # now go through rest of potential websites
    # TODO: eventually just flip them off without muting
    # TODO: eventually have restore for all of these
    xdotool windowminimize "${line}"
    amixer set Master mute
done
if [[ "$1" == '--pause' ]];then
    # filtering by name probably cuts out more windows more quickly than class
    # turn off youtube even if not visible
    xdotool search --name "twitch|youtube" | while IFS= read -r line; do
        if xdotool search --class conkeror | grep -- "${line}" >/dev/null; then
            xdotool windowfocus --sync "${line}";
            # TODO: very arbitrary delay, perhaps wait for something to return
            sleep 0.05
            ${HOME}/bin/conkeror-batch -f web-video-pause
            [[ "${line}" == "${CURRENTWINDOW}" ]] && CURRENTYOUTUBE=1
        fi
    done
    # restore focus if not youtube window
    # XXXX only need for youtube because I focused to use pause api
    [[ -n "$CURRENTYOUTUBE" ]] && xdotool windowactivate --sync ${CURRENTWINDOW}
fi

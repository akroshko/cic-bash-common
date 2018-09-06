#!/bin/bash

# overwrite if window no longer exists

if [[ -e /tmp/cic-web-video-last.txt ]]; then
    WINID=$(sed -n '1p' /tmp/cic-web-video-last.txt)
    WINCLASS=$(sed -n '2p' /tmp/cic-web-video-last.txt)
    # does winid exist and what is its class
    WINID_EXIST=$(xdotool search --name "" | grep -i "$WINID")
    WINCLASS_EXIST=$(xprop WM_CLASS -id "$WINID_EXIST")
    echo "$WINID"
    echo "$WINCLASS"
    echo "$WINID_EXIST"
    echo "$WINCLASS_EXIST"
    if [[ -n "$WINID_EXIST" && -n "$WINCLASS_EXIST" ]]; then
        echo "Restoring"
        xdotool windowactivate --sync "${WINID}"
        sleep 0.5
        if echo "$WINCLASS_EXIST" | grep -i dolphin &>/dev/null && echo "$WINCLASS_EXIST" | grep -i dolphin &>/dev/null; then
            echo "Dolphin"
            xdotool keydown --window "$WINID" "F10"
            sleep 0.05
            xdotool keyup   --window "$WINID" "F10"
        elif echo "$WINCLASS_EXIST" grep -i mpv &>/dev/null && echo "$WINCLASS_EXIST" | grep -i mpv &>/dev/null; then
            echo "MPV"
            xdotool windowactivate --sync "${WINID}" key "space"
        elif echo "$WINCLASS_EXIST" grep -i conkeror &>/dev/null && echo "$WINCLASS_EXIST" | grep -i conkeror &>/dev/null; then
            echo "Conkeror"
            if xdotool search --name "twitch|youtube" | grep -- "${WINID}" >/dev/null; then
                # TODO: very arbitrary delay, perhaps wait for something to return
                sleep 0.5
                "${HOME}/bin/conkeror-batch" -f web-video-play
                sleep 0.5
            fi
        fi
    fi
fi

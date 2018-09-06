#!/bin/bash

# find the best candidate for currently playing video
# TODO: add more intelligence
xdotool search --name "twitch|youtube" | while IFS= read -r WINID; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
        FOCUSID=$(xdotool getwindowfocus)
        echo "$FOCUSID" > /tmp/cic-web-video-focus-last.txt
        echo $(xprop WM_CLASS -id "$FOCUSID") >> /tmp/cic-web-video-focus-last.txt
        xdotool windowactivate --sync "${WINID}"
        exit 0
    fi
done

# focus programs
xdotool search --class "dolphin-emu|Fceux|mGBA|mpv|PCSXR|PPSSPPSDL|vlc|zsnes" | while IFS= read -r WINID; do
    FOCUSID=$(xdotool getwindowfocus)
    echo $FOCUSID
    echo "$FOCUSID" > /tmp/cic-web-video-focus-last.txt
    echo $(xprop WM_CLASS -id "$FOCUSID") >> /tmp/cic-web-video-focus-last.txt
    xdotool windowactivate --sync "${WINID}"
    exit 0
done

#!/bin/bash

if [[ -e /tmp/cic-web-video-focus-last.txt ]]; then
    WINID=$(sed -n '1p' /tmp/cic-web-video-focus-last.txt)
    WINCLASS=$(sed -n '2p' /tmp/cic-web-video-focus-last.txt)
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
    fi
fi

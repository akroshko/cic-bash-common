#!/bin/bash

# overwrite if window no longer exists

main () {
    if (( "$(ps -ef | grep '[w]eb-video' | wc -l)" > 2 )); then
        echo "A web-video script is already running!"
        exit 1
    fi

    if [[ -e /tmp/cic-web-video-last.txt ]]; then
        local WINID=$(sed -n '1p' /tmp/cic-web-video-last.txt)
        local WINCLASS=$(sed -n '2p' /tmp/cic-web-video-last.txt)
        # does winid exist and what is its class
        local WINID_EXIST=$(xdotool search --name "" | grep -i "$WINID")
        local WINCLASS_EXIST=$(xprop WM_CLASS -id "$WINID_EXIST")
        echo "$WINID"
        echo "$WINCLASS"
        echo "$WINID_EXIST"
        echo "$WINCLASS_EXIST"
        if [[ -n "$WINID_EXIST" && -n "$WINCLASS_EXIST" ]]; then
            echo "Restoring"
            xdotool windowactivate --sync "${WINID}"
            sleep 0.5
            if grep -i dolphin <<< "$WINCLASS_EXIST" &>/dev/null && grep -i dolphin <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "Dolphin"
                xdotool keydown --delay 50 --window "$WINID" "F10" keyup --delay 50 --window "$WINID" "F10"
            elif grep -i mpv <<< "$WINCLASS_EXIST" &>/dev/null && grep -i mpv <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "MPV"
                xdotool windowactivate --sync "${WINID}" key "space"
            elif grep -i conkeror <<< "$WINCLASS_EXIST" &>/dev/null && grep -i conkeror <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "Conkeror"
                if xdotool search --name "twitch|youtube" | grep -- "${WINID}" >/dev/null; then
                    # TODO: very arbitrary delay, perhaps wait for something to return
                    sleep 0.5
                    "$HOME/bin/conkeror-batch" -f web-video-play
                    sleep 0.5
                fi
            fi
        fi
    fi
}
main "$@"

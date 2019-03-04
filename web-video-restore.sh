#!/bin/bash

# overwrite if window no longer exists

main () {
    # TODO: boilerplate
    local LOCKFILE=/tmp/web-video-only-lock.txt
    if [[ -e "$LOCKFILE" ]]; then
        local LOCKFILE_CONTENTS=$(cat "$LOCKFILE")
        if kill -0 "$LOCKFILE_CONTENTS" &>/dev/null; then
            echo "Found $LOCKFILE pid $LOCKFILE_CONTENTS"
            # TODO: fix up this grep so I check for something valid
            if ps -ef | grep "$LOCKFILE_CONTENTS.*"'[w]eb-video' &>/dev/null; then
                echo "A web-video script is already running!"
                exit 1
            else
                echo "Running because $LOCKFILE contents stale"
            fi
        fi
    fi
    echo $$ > "$LOCKFILE"

    # TODO: this should be standard after LOCKFILE
    local CURRENTWINDOW=$(xdotool getwindowfocus)

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
            xdotool windowactivate --sync "$WINID"
            sleep 0.5
            # TODO: fix up this grep so I check for something valid
            if grep -i dolphin <<< "$WINCLASS_EXIST" &>/dev/null && grep -i dolphin <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "Dolphin"
                xdotool keydown --delay 50 --window "$WINID" "F10" keyup --delay 50 --window "$WINID" "F10"
            elif grep -i mpv <<< "$WINCLASS_EXIST" &>/dev/null && grep -i mpv <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "MPV"
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" key "space"
            elif grep -i vlc <<< "$WINCLASS_EXIST" &>/dev/null && grep -i vlc <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "vlc"
                echo "play" | nc -q 2 localhost 19555
                # TODO: can I cut these sleeps, or should I give tVLC thismuch time to settle
                sleep 0.25
                # xdotool windowactivate --sync "$CURRENTWINDOW"
            elif grep -i conkeror <<< "$WINCLASS_EXIST" &>/dev/null && grep -i conkeror <<< "$WINCLASS_EXIST" &>/dev/null; then
                echo "Conkeror"
                if xdotool search --name "twitch|youtube" | grep -- "$WINID" >/dev/null; then
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

#!/bin/bash

main () {
    # TODO: boilerplate
    local LOCKFILE=/tmp/web-video-only-lock.txt
    if [[ -e "$LOCKFILE" ]]; then
        local LOCKFILE_CONTENTS=$(cat "$LOCKFILE")
        if kill -0 "$LOCKFILE_CONTENTS" &>/dev/null; then
            echo "Found $LOCKFILE pid $LOCKFILE_CONTENTS"
            if ps -ef | grep "$LOCKFILE_CONTENTS.*"'[w]eb-video' &>/dev/null; then
                echo "A web-video script is already running!"
                exit 1
            else
                echo "Running because $LOCKFILE contents stale"
            fi
        fi
    fi
    echo $$ > "$LOCKFILE"

    # find the best candidate for currently playing video
    # TODO: add more intelligence
    xdotool search --name "twitch|youtube" | while IFS= read -r WINID; do
        if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
            local FOCUSID=$(xdotool getwindowfocus)
            echo "$FOCUSID" > /tmp/cic-web-video-focus-last.txt
            echo $(xprop WM_CLASS -id "$FOCUSID") >> /tmp/cic-web-video-focus-last.txt
            xdotool windowactivate --sync "${WINID}"
            exit 0
        fi
    done

    # focus programs
    xdotool search --class "dolphin-emu|Fceux|mGBA|mpv|PCSXR|PCSX2|PPSSPPSDL|vlc|zsnes" | while IFS= read -r WINID; do
        local FOCUSID=$(xdotool getwindowfocus)
        echo $FOCUSID
        echo "$FOCUSID" > /tmp/cic-web-video-focus-last.txt
        echo $(xprop WM_CLASS -id "$FOCUSID") >> /tmp/cic-web-video-focus-last.txt
        xdotool windowactivate --sync "${WINID}"
        exit 0
    done
}
main "$@"

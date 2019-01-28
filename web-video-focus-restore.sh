#!/bin/bash

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

    if [[ -e /tmp/cic-web-video-focus-last.txt ]]; then
        local WINID=$(sed -n '1p' /tmp/cic-web-video-focus-last.txt)
        local WINCLASS=$(sed -n '2p' /tmp/cic-web-video-focus-last.txt)
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
        fi
    fi
}
main "$@"

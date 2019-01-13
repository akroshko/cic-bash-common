#!/bin/bash
# global function to pause a running Youtube in Conkeror
# get current window

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

    local CURRENTWINDOW=$(xdotool getwindowfocus)
    local CURRENTYOUTUBE=
    # filtering by name probably cuts out more windows more quickly than class
    xdotool search --name "twitch|youtube" | while IFS= read -r line; do
        if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "${line}" >/dev/null; then
            xdotool windowfocus --sync "${line}"
            # TODO: very arbitrary delay, perhaps wait for something to return
            sleep 0.05
            "$HOME/bin/conkeror-batch" -f web-video-pause-toggle
            [[ "${line}" == "${CURRENTWINDOW}" ]] && CURRENTYOUTUBE=1
        fi
    done
    xdotool windowactivate --sync ${CURRENTWINDOW}
    # TODO: should have an if before xdotool, but couldn't get it working in 5 minutes
    # restore focus if not youtube window
    # if [[ -n "$CURRENTYOUTUBE" ]]; then
    # fi
}
main "$@"

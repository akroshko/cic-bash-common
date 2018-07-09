#!/bin/bash
# global function to minimize with the option to pausing running videos or other media
# get current window
# TODO: actually time this and find something that goes faster, takes about 2-3s? but at least it minimizes first
# TODO: case sensitive/insensitive search
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# TODO minimize all windows first
# filtering by name probably cuts out more windows more quickly than class
# TODO: need global regex for this
# minimize always minimizes video sites
xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "${line}" >/dev/null; then
        xdotool windowminimize "${line}"
    fi
done
# get rid of social media if all is used
if [[ "$1" == "--all" ]]; then
    xdotool search --onlyvisible --name "facebook|instagram|pixiv|twitter" | while IFS= read -r line; do
        if xdotool search --class "chromium-browser|conkeror|firefox" | grep -- "${line}" >/dev/null; then
            xdotool windowminimize "${line}"
            sleep 0.10
        fi
    done
fi

# always pause playback or emulation
xdotool search --class "dolphin-emu|Fceux|mGBA|mpv|PCSXR|PPSSPPSDL|vlc|zsnes" | while IFS= read -r line; do
    # now go through rest of potential websites
    # TODO: eventually just flip them off without muting
    # TODO: eventually have restore for all of these
    if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
        THECLASS=$(xprop WM_CLASS -id "${line}")
        # appears to be case insensitve
        # TODO: make sure one day
        if [[ "${THECLASS}" =~ "mpv" ]]; then
            # TODO: figure out if I can force pause
            xdotool windowfocus --sync "${line}" key "space"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "vlc" ]]; then
            # space pauses, browser stop key stops
            xdotool windowfocus --sync "${line}" key "XF86Stop"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "dolphin" ]]; then
            # TODO: only one of about 8 window ids will be successful, unfortunately hard to tell unless trying them all
            xdotool windowfocus --sync "${line}" key "F10"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "Fceux" ]]; then
            # TODO: this may toggle caps
            xdotool windowfocus --sync "${line}" key "Pause"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "mGBA" ]]; then
            # TODO: this may toggle caps
            xdotool windowfocus --sync "${line}" key "ctrl+p"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "PCSXR" ]]; then
            # TODO: this may toggle caps
            xdotool windowfocus --sync "${line}" key "Escape"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "PPSSPPSDL" ]]; then
            xdotool windowfocus --sync "${line}" key "Escape"
            sleep 0.05
        elif [[ "${THECLASS}" =~ "zsnes" ]]; then
            xdotool windowfocus --sync "${line}" key "Escape"
            sleep 0.05
        else
            if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
                # TODO: do I really need this
                # amixer set Master mute
                true
            fi
        fi
    fi
    xdotool windowminimize "${line}"
    sleep 0.10
    # mute only if I try to pause or boss key mode
    # TODO: reenable
done
# try to pause videos if --all is used too
if [[ "$1" == '--pause' || "$1" == '--all' ]];then
    # filtering by name probably cuts out more windows more quickly than class
    # turn off youtube even if not visible
    # TODO there does not seem to be a way to do two searches in one command
    xdotool search --name "twitch|youtube" | while IFS= read -r line; do
        if xdotool search --class "conkeror" | grep -- "${line}" >/dev/null; then
            xdotool windowfocus --sync "${line}";
            # TODO: very arbitrary delay, perhaps wait for something to return
            # TODO definitely want this better
            sleep 0.10
            ${HOME}/bin/conkeror-batch -f web-video-pause
            # [[ "${line}" == "${CURRENTWINDOW}" ]] && CURRENTYOUTUBE=1
        fi
    done
    # restore focus if not youtube window
    # XXXX only need for youtube and twitch because I focused to use pause api
    # [[ -n "$CURRENTYOUTUBE" ]] && xdotool windowactivate --sync ${CURRENTWINDOW}
fi

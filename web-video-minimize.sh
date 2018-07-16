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
# get rid of social media if all is used

if [[ "$1" == "--all" || "$1" == "--pause" ]]; then
    xdotool search --onlyvisible --name "game|facebook|instagram|pixiv|strava|twitter|wikia" | while IFS= read -r WINID; do
        if xdotool search --onlyvisible --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
            xdotool windowminimize "$WINID"
            sleep 0.10
        fi
    done
fi
# get rid of downloads and documents directory
if [[ "$1" == "--all" || "$1" == "--pause" ]]; then
    xdotool search --onlyvisible --name "downloads|documents" | while IFS= read -r WINID; do
        if xdotool search --onlyvisible --class "pcmanfm" | grep -- "$WINID" >/dev/null; then
            xdotool windowminimize "${WINID}"
            sleep 0.10
        fi
    done
fi

# Dolpin has a few problems so it is seperate
# very conservative sleeps
xdotool search --class "dolphin-emu" | while IFS= read -r WINID; do
    if xdotool search --name "FPS" | grep "$WINID" &>/dev/null; then
        echo "$WINID"
        # TODO: wmctrl seems more robust than xdotool for this but investigage more
        # xdotool windowactivate "$WINID" windowfocus --sync "$WINID"
        wmctrl -i -R "$WINID"
        # xdotool windowactivate --sync "$WINID"
        sleep 0.5
        # dolphin seems to poll periodically for the key being depressed
        # just a keypress even is only detected about 25% of the time
        xdotool keydown --window "$WINID" "F10"
        sleep 0.05
        xdotool keyup   --window "$WINID" "F10"
        # at least some sleep delay after inputting key seems to help
        sleep 1
    fi
done

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
            xdotool windowactivate --sync "${line}" key "space"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "vlc" ]]; then
            # space pauses, browser stop key stops
            xdotool windowactivate --sync "${line}" key "XF86Stop"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "Fceux" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${line}" key --window  "${line}" "Pause"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "mGBA" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${line}" key --window  "${line}" "ctrl+p"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "PCSXR" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${line}" key --window  "${line}" "Escape"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "PPSSPPSDL" ]]; then
            xdotool windowactivate --sync "${line}" key --window  "${line}" "Escape"
            sleep 0.5
        elif [[ "${THECLASS}" =~ "zsnes" ]]; then
            xdotool windowactivate --sync "${line}" key --window  "${line}" "Escape"
            sleep 0.5
        else
            if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
                # TODO: do I really need this
                # amixer set Master mute
                true
            fi
        fi
    fi
    sleep 0.25
    xdotool windowminimize "${line}"
    sleep 0.25
    # mute only if I try to pause or boss key mode
    # TODO: reenable
done
# try to pause videos if --all is used too
if [[ "$1" == '--pause' || "$1" == '--all' ]];then
    # filtering by name probably cuts out more windows more quickly than class
    # turn off youtube even if not visible
    # TODO there does not seem to be a way to do two searches in one command
    xdotool  search --name "twitch|youtube" | while IFS= read -r line; do
        if xdotool search --class "conkeror"  | grep -- "$WINID" >/dev/null; then
            xdotool windowactivate --sync "${line}";
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

xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r WINID; do
    if xdotool search --onlyvisible --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
        xdotool windowminimize "$WINID"
        sleep 0.10
    fi
    sleep 0.05
done

#!/bin/bash
# global function to minimize with the option to pausing running videos or other media

# TODO: put in tmp directory?
# TODO: make sure null operations do not overwrite last
echo "" > /tmp/cic-web-video-last.txt

# XXXX: sleep 0.10 is generally to just ensure that nothing happens too rapid fire
# XXXX: sleep 0.25 generally ensures window recieves key
# XXXX: sleep 1.0 is to make sure conkeror reacts

# filtering by name probably cuts out more windows more quickly than class
# TODO: need global regex for this
# minimize always minimizes video sites and get rid of social media first
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

# Dolpin has a few problems so it is in a seperate place
# very conservative sleeps
xdotool search --class "dolphin-emu" | while IFS= read -r WINID; do
    if xdotool search --name "FPS" | grep "$WINID" &>/dev/null; then
        echo "$WINID"
        # TODO: wmctrl seems more robust than xdotool for this but investigage more
        # xdotool windowactivate "$WINID" windowfocus --sync "$WINID"
        wmctrl -i -R "$WINID"
        # xdotool windowactivate --sync "$WINID"
        sleep 0.25
        # dolphin seems to poll periodically for the key being depressed
        # just a keypress even is only detected about 25% of the time
        xdotool keydown --window "$WINID" "F10"
        sleep 0.05
        xdotool keyup   --window "$WINID" "F10"
        # at least some sleep delay after inputting key seems to help
        sleep 1
        echo "$WINID" > /tmp/cic-web-video-last.txt
        echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
    fi
done

# always pause playback or emulation
xdotool search --class "dolphin-emu|Fceux|mGBA|mpv|PCSXR|PPSSPPSDL|vlc|zsnes" | while IFS= read -r WINID; do
    # now go through rest of potential websites
    # TODO: eventually just flip them off without muting
    # TODO: eventually have restore for all of these
    if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
        THECLASS=$(xprop WM_CLASS -id "${WINID}")
        # appears to be case insensitve
        # TODO: make sure one day
        if [[ "${THECLASS}" =~ "mpv" ]]; then
            # TODO: figure out if I can force pause
            xdotool windowactivate --sync "${WINID}" key "space"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "vlc" ]]; then
            # space pauses, browser stop key stops
            xdotool windowactivate --sync "${WINID}" key "XF86Stop"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "Fceux" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${WINID}" key --window  "${WINID}" "Pause"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "mGBA" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${WINID}" key --window  "${WINID}" "ctrl+p"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "PCSXR" ]]; then
            # TODO: this may toggle caps
            xdotool windowactivate --sync "${WINID}" key --window  "${WINID}" "Escape"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "PPSSPPSDL" ]]; then
            xdotool windowactivate --sync "${WINID}" key --window  "${WINID}" "Escape"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        elif [[ "${THECLASS}" =~ "zsnes" ]]; then
            xdotool windowactivate --sync "${WINID}" key --window  "${WINID}" "Escape"
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        else
            if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
                # TODO: do I really need this
                # amixer set Master mute
                true
            fi
        fi
    fi
    sleep 0.25
    xdotool windowminimize "${WINID}"
    sleep 0.25
    # mute only if I try to pause or boss key mode
    # TODO: reenable
done
# try to pause videos if --all is used too
if [[ "$1" == '--pause' || "$1" == '--all' ]];then
    # filtering by name probably cuts out more windows more quickly than class
    # turn off youtube even if not visible
    # TODO there does not seem to be a way to do two searches in one command
    xdotool  search --name "twitch|youtube" | while IFS= read -r WINID; do
        if xdotool search --class "conkeror"  | grep -- "$WINID" >/dev/null; then
            xdotool windowactivate --sync "${WINID}"
            # TODO: very arbitrary delay, perhaps wait for something to return
            # TODO definitely want this better
            # TODO: should not be necessary because of --sync
            sleep 0.25
            # TODO: can I wait for this to return
            "$HOME/bin/conkeror-batch" -f web-video-pause
            sleep 1.0
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "${WINID}") >> /tmp/cic-web-video-last.txt
        fi
    done
fi

xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r WINID; do
    if xdotool search --onlyvisible --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
        sleep 0.10
        xdotool windowminimize "${WINID}"
        sleep 0.10
        # TODO: probably no need for sleep here
        echo "$WINID" > /tmp/cic-web-video-last.txt
        echo $(xprop WM_CLASS -id "${WINID}") >> /tmp/cic-web-video-last.txt
    fi
done

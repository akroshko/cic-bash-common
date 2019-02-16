#!/bin/bash
# global function to minimize with the option to pausing running videos or other media

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
            if [[ -n "$WINID" ]] && xdotool search --onlyvisible --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
                xdotool windowminimize "$WINID"
                sleep 0.10
            fi
        done
    fi
    # get rid of downloads and documents directory
    if [[ "$1" == "--all" || "$1" == "--pause" ]]; then
        xdotool search --onlyvisible --name "downloads|documents" | while IFS= read -r WINID; do
            if [[ -n "$WINID" ]] && xdotool search --onlyvisible --class "pcmanfm" | grep -- "$WINID" >/dev/null; then
                xdotool windowminimize "$WINID"
                sleep 0.10
            fi
        done
    fi

    # Dolpin has a few problems so it is in a seperate place
    # very conservative sleeps
    xdotool search --class "dolphin-emu" | while IFS= read -r WINID; do
        if [[ -n "$WINID" ]] && xdotool search --name "FPS" | grep "$WINID" &>/dev/null; then
            echo "$WINID"
            # TODO: wmctrl seems more robust than xdotool for this than xdotool getwindowfocus
            wmctrl -i -R "$WINID"
            sleep 0.25
            # dolphin seems to poll periodically for the key being depressed
            # just a keypress even is only detected about 25% of the time
            xdotool keydown --delay 50 --window "$WINID" "F10" keyup --delay 50 --window "$WINID" "F10"
            # at least some sleep delay after inputting key seems to help
            sleep 0.25
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        fi
    done

    # always pause playback or emulation
    xdotool search --class --onlyvisible --maxdepth 2 "dolphin-emu|Fceux|mGBA|mpv|PCSXR|PCSX2|PPSSPPSDL|vlc|zsnes" | while IFS= read -r WINID; do
        # now go through rest of potential websites
        # TODO: eventually just flip them off without muting
        # TODO: eventually have restore for all of these
        if [[ "$1" == '--pause' || "$1" == '--all' ]]; then
            THECLASS=$(xprop WM_CLASS -id "$WINID")
            # appears to be case insensitve
            # TODO: make sure one day
            if [[ "$THECLASS" =~ "mpv" ]]; then
                # TODO: figure out if I can force pause
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "space"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "vlc" ]]; then
                # TODO: requires different from default config
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "F10"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "Fceux" ]]; then
                # TODO: this may toggle caps
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "Pause"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "mGBA" ]]; then
                # TODO: this may toggle caps
                xdotool getwindowfocus key --window  "$WINID" "ctrl+p"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "PCSXR" ]]; then
                # TODO: this may toggle caps
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "Escape"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "PCSX2" ]]; then
                # TODO: wmctrl seems more robust than xdotool for this than xdotool getwindowfocus
                # xdotool getwindowfocus --sync "$WINID" key --window  "$WINID" "Escape"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "PPSSPPSDL" ]]; then
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "Escape"
                sleep 0.25
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            elif [[ "$THECLASS" =~ "zsnes" ]]; then
                wmctrl -i -R "$WINID"
                sleep 0.25
                xdotool getwindowfocus key --window "%1" "Escape"
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
        # TODO: can I fork this off
        sleep 0.25
        xdotool windowminimize "$WINID"
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
            if [[ -n "$WINID" ]] && xdotool search --class "conkeror"  | grep -- "$WINID" >/dev/null; then
                wmctrl -i -R "$WINID"
                # TODO: very arbitrary delay, perhaps wait for something to return
                # TODO definitely want this better
                # TODO: should not be necessary because of --sync
                sleep 0.25
                # TODO: can I wait for this to return
                "$HOME/bin/conkeror-batch" -f web-video-pause
                sleep 1.0
                echo "$WINID" > /tmp/cic-web-video-last.txt
                echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
            fi
        done
    fi

    xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r WINID; do
        if [[ -n "$WINID" ]] && xdotool search --onlyvisible --class "chromium-browser|conkeror|firefox" | grep -- "$WINID" >/dev/null; then
            sleep 0.10
            xdotool windowminimize "$WINID"
            sleep 0.10
            # TODO: probably no need for sleep here
            echo "$WINID" > /tmp/cic-web-video-last.txt
            echo $(xprop WM_CLASS -id "$WINID") >> /tmp/cic-web-video-last.txt
        fi
    done
}
main "$@"

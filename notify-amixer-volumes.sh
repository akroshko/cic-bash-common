#!/bin/bash

amixer-volumes () {
    # delay required after changing volume to avoid inaccurate display of mixer levels
    sleep 0.15
    amixer get Master | grep --color=never  'Front.*Playback' | tr "\\n" " " | sed -e 's/Front//g' -e 's/Playback//g' -e 's/\s[0-9]\+//g' -e 's/  */ /g'
}
notify-send "$(amixer-volumes)" -t 200

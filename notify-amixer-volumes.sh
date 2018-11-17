#!/bin/bash

amixer-volumes () {
    echo $(amixer get Master | grep Front.*Playback | tr "\\n" " " | sed -e 's/Front//g' -e 's/Playback//g' -e 's/\s[0-9]\+//g' -e 's/  */ /g')
}

notify-send "$(amixer-volumes)" -t 200

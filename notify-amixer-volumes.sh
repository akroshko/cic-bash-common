#!/bin/bash

amixer-volumes () {
    # TODO: this is necessary to avoid inaccurate display of the volume levels
    sleep 0.05
    echo $(amixer get Master | grep Front.*Playback | tr "\\n" " " | sed -e 's/Front//g' -e 's/Playback//g' -e 's/\s[0-9]\+//g' -e 's/  */ /g')
}
notify-send "$(amixer-volumes)" -t 200

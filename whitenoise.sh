#!/bin/bash
# whitenoise.sh is a script that runs/pauses/unpauses a playing a
# particular sound file
#
# Copyright (C) 2015-2018, Andrew Kroshko, all rights reserved.
#
# Author: Andrew Kroshko
# Maintainer: Andrew Kroshko <akroshko.public+devel@gmail.com>
# Created: Sun Sep 20, 2015
# Version: 20180918
# URL: https://github.com/akroshko/bash-stdlib
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
########################################################################
#
# This script is often used to quickly play/unplay background noise in
# file defined by $BACKGROUNDNOISE in my .bashrc currently.  Use
# $BACKGROUNDNOISESUBSTRING to define a unique substring for nice
# interaction with shortcuts in window managers.
source ~/.bash_library
# TODO: define exactly why it is useful for this to be a seperate script?
# check if whitenoise already running
ALREADYRUNNING=0
# INDEX=0
# INDEXTORUN=0
# TODO: make more universal, check if playing
for SS in "${BACKGROUNDNOISESUBSTRINGS[@]}";do
    # TODO: get rid of grep -v grep
    if ps -ef | grep -- "${SS}" | grep -v grep >/dev/null; then
        ALREADYRUNNING=1
    fi
done
if [[ -z "$1" && "$ALREADYRUNNING" == 1 ]]; then
    echo "pause" | nc -q 2 localhost 19000
    sleep 1
elif [[ -n "$1" && "$ALREADYRUNNING" == 1 ]]; then
    # make sure to reuse existing
    # rxvt-unicode -title "White noise" -e cvlc --rc-host localhost:19000 --extraintf oldrc --intf dummy "${BACKGROUNDNOISE[$INDEXTORUN]}"
    echo "next" | nc -q 2 localhost 19000
    sleep 1
else
    # play the first one
    if [[ -z "$1" ]] ;then
        (nohup rxvt-unicode -title "White noise" -e cvlc --rc-host localhost:19000 --extraintf oldrc --intf dummy "${BACKGROUNDNOISE[0]}" &>/dev/null &)
    else
        (nohup rxvt-unicode -title "White noise" -e cvlc --rc-host localhost:19000 --extraintf oldrc --intf dummy "${BACKGROUNDNOISE[1]}" &>/dev/null &)
    fi
    sleep 2
    FIRSTITEM=1
    for WN in "${BACKGROUNDNOISE[@]}";do
        if [[ "$FIRSTITEM" == 1 ]]; then
            FIRSTITEM=0
            continue
        fi
        echo "enqueue ${WN}" | nc -q 2 localhost 19000
        sleep 1
    done
    # let the playlist loop
    echo "loop" | nc -q 2 localhost 19000
    sleep 1
fi

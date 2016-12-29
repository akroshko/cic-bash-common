#!/bin/bash -i
# whitenoise.sh is a script that runs/pauses/unpauses a playing a
# particular sound file
#
# Copyright (C) 2015-2016, Andrew Kroshko, all rights reserved.
#
# Author: Andrew Kroshko
# Maintainer: Andrew Kroshko <akroshko.public+devel@gmail.com>
# Created: Sun Sep 20, 2015
# Version: 20160716
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
# interaction with xbindkeys or other shortcut managers.

# TODO: define exactly why it is useful for this to be a seperate script?
#       could be a good f12 thing

if ps -ef | grep "${BACKGROUNDNOISESUBSTRING}" | grep -v grep >/dev/null; then
    echo "pause" | nc -q 2 localhost 19000
else
    rxvt-unicode -title "White noise" -e cvlc --rc-host localhost:19000 --extraintf oldrc --intf dummy "$BACKGROUNDNOISE"
fi

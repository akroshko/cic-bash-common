#!/bin/bash -i
# whitenoise.sh is a script that runs/pauses/unpauses a playing a
# particular sound file
#
# Copyright (C) 2015-2016 Andrew Kroshko, all rights reserved.
#
# Author: Andrew Kroshko
# Maintainer: Andrew Kroshko <akroshko.public+devel@gmail.com>
# Created: Sun Sep 20, 2015
# Version: 20160130
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
# file defined by $BACKGROUNDNOISE in my .bashrc currently very nice
# interacting with xbindkeys or other shortcut managers

# TODO: configure this?
if ps -ef | grep "kH-kj6rkQWc" | grep -v grep > /dev/null
then
    echo "pause" | nc -q 2 localhost 19000
else
    gnome-terminal --title="White noise" --execute cvlc --rc-host localhost:19000 --extraintf oldrc --intf dummy "$BACKGROUNDNOISE"
fi

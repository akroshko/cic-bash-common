#!/bin/bash
# xclip-primary-insert-emacs-collection.sh gets the current X11
# primary selection encoded as base64 and inserts it in the
# *Collection* buffer in emacs
#
# Copyright (C) 2015-2019, Andrew Kroshko, all rights reserved.
#
# Author: Andrew Kroshko
# Maintainer: Andrew Kroshko <akroshko.public+devel@gmail.com>
# Created: Tue Oct 17, 2017
# Version: 20181209
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

source "$HOME/.bash_library"

main () {
    # TODO: clipboard instead...
    if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep -- "$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed -e 's/,//' -e 's/0x0*//g').*zathura.Zathura"; then
        local CAPTUREDPRIMARY=$(xclip -l 1 -o -selection clipboard)
    else
        local CAPTUREDPRIMARY=$(xclip -l 1 -o -selection primary)
    fi
    local BASE64CONVERT=$(base64 <<< "$CAPTUREDPRIMARY")
    # first t grabs from primary, second t is nograb
    "$HOME/bin/launch-emacsclient" noframe --eval "(cic:insert-collection \"${BASE64CONVERT}\")"
    notify-send "Added to collection!!!\n\n$CAPTUREDPRIMARY" -t 5000
    log-collection "$BASE64CONVERT"
}
main

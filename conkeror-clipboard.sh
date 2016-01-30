#!/bin/bash
# conkeror-clipboard.sh is a bash script that calls various search
# engines using the contents of the X11 clipboard
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
# create a really nice prompt for most terminals

google () {
    local CLIPBOARD=`xclip -o selection c`
    CLIPBOARD="${CLIPBOARD// /+}"
    conkeror "https://google.ca/search?q=$CLIPBOARD"
}

scholar () {
    local CLIPBOARD=`xclip -o selection c`
    CLIPBOARD="${CLIPBOARD// /+}"
    conkeror "https://scholar.google.ca/scholar?q=$CLIPBOARD"
}

wikipedia () {
    local CLIPBOARD=`xclip -o selection c`
    CLIPBOARD="${CLIPBOARD// /+}"
    conkeror "https://en.wikipedia.org/w/index.php?search=$CLIPBOARD"
}

$@

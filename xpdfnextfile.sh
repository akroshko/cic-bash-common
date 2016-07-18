#!/bin/bash
# xpdfnextfile.sh is a helper function to go to next .pdf file in directory
#
# Copyright (C) 2016, Andrew Kroshko, all rights reserved.
#
# Author: Andrew Kroshko
# Maintainer: Andrew Kroshko <akroshko.public+devel@gmail.com>
# Created: Sun Jul 17, 2016
# Version: 20160717
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

# symlink to home directory (with dot in front) and use with https://github.com/akroshko/dotfiles-stdlib/xpdfrc

next-pdf-same-directory () {
    # $1 is a full path, get the directory name
    local current_fname="$1"
    local found=1
    local next=$(IFS=$(echo -en "\n\b")
                 for f in $(dirname $1)/*.pdf; do
                     if [[ $found == 0 ]]; then
                         echo "$f"
                         break;
                     fi
                     if [[ "$f" == "$current_fname" ]]; then
                         found=0
                     fi
                 done)
    echo "$next"
}

if [[ -n "$1" ]];then
    if [[ -f "${PWD}/$1" ]]; then
        NEWFILE=$(next-pdf-same-directory "${PWD}/$1")
    else
        NEWFILE=$(next-pdf-same-directory "$1")
    fi
    xpdf -remote desktop-open "$NEWFILE"
fi

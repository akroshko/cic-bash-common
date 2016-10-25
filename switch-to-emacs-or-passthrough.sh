#!/bin/bash
echo "test"
if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep "$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed 's/,//' | sed -e 's/0x0*//g')" | grep emacs.Emacs; then
    # open xpdf or switch to other remote
    # TODO: non-released key combo
    xdotool key alt+"A"
else
    wmctrl -x -a emacs.Emacs
fi

#!/bin/bash
# TODO: what does this do? seems to check if emacs is current active window, put into function and test?
if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep -- "$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed 's/,//' | sed -e 's/0x0*//g')" | grep emacs.Emacs; then
    WINID=$(sed -n '1p' $HOME/.emacs-switch-last.txt)
    xdotool windowactivate --sync "$WINID"
fi

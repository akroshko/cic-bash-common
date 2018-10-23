#!/bin/bash
if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep -- "$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed -e 's/,//' -e 's/0x0*//g').*zathura.Zathura"; then
    # TODO: no echo?
    echo $(xdotool getwindowfocus) > "$HOME/.emacs-switch-last.txt"
    wmctrl -x -a emacs.Emacs
else
    WINID=$(xdotool getwindowfocus)
    # windowactivate --sync "${WINID}"
    xdotool key --window  "${WINID}" "super+c"
fi

#!/bin/bash
# TODO: what does this do? seems to check if emacs is current window
if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep "$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed 's/,//' | sed -e 's/0x0*//g')" | grep emacs.Emacs; then
    # let alt+"e" pass through
    # XXXX: change this to something else if using key other than alt+"e"
    # XXXX: emacs command alt+"e" is next frame (could be something to switch out of emacs)
    # xdotool key meta+e
    /home/akroshko/cic-vcs/bash-stdlib/launch-emacsclient noframe --eval "(other-frame 1)"
else
    wmctrl -x -a emacs.Emacs
fi

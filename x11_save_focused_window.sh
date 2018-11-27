#!/bin/bash
# TODO: this is emacs focused right now
echo "" >> /tmp/cic-x11-saved-focused-window.txt
WINID=$(xdotool getwindowfocus)
# double quotes rather than single quotes
sed -i "1i$WINID" /tmp/cic-x11-saved-focused-window.txt
sed -i '/^\s*$/d' /tmp/cic-x11-saved-focused-window.txt
sed -i '11,$ d'   /tmp/cic-x11-saved-focused-window.txt

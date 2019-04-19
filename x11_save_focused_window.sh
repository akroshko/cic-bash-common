#!/bin/bash
# save the currently focused window to a tmp file so it can be restored
# TODO: eventually eliminate duplicated lines
# TODO: security implications of tmp file may need to be considered

# ensure there is a newline at the end of the tmp file
echo "" >> /tmp/cic-x11-saved-focused-window.txt
WINID=$(xdotool getwindowfocus)
# double quotes for sed when referencing variable rather than single quotes
# add $WINID to the first line of the tmp file
sed -i "1i$WINID" /tmp/cic-x11-saved-focused-window.txt
# remove blank lines from the tmp file
sed -i '/^\s*$/d' /tmp/cic-x11-saved-focused-window.txt
# limit to 10 saved windows in the tmp file
sed -i '11,$ d'   /tmp/cic-x11-saved-focused-window.txt

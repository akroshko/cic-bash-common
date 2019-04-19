#!/bin/bash
# restore the window saved from first line of the tmp file for now
# TODO: security implications of tmp file may need to be considered

# TODO: openbox often buries a window called by this
xdotool windowactivate --sync $(sed -n '1p' /tmp/cic-x11-saved-focused-window.txt)

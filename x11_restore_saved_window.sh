#!/bin/bash
# TODO: this is emacs focused right now
# TODO: is this often run from emacs
# openbox often buries a window called by this
# restore the one saved
xdotool windowactivate --sync $(sed -n '1p' /tmp/cic-x11-saved-focused-window.txt)

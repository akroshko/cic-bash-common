#!/bin/bash
main () {
    DOCUMENTMASTER="$1"
    zathura "$@"
    # TODO: obviously fix this before commit
    # TODO: want something that does not raise
    sleep 0.2
    WINNAME=$(wmctrl -lx | awk '{print $1 " " $3 " " $5}' | grep zathura.Zathura | grep "$DOCUMENTMASTER" | awk '{print $3}')
    wmctrl -a "$WINNAME"
}
main "$@"

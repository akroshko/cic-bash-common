#!/bin/bash
# this function is used when calling zathura from AucTeX in Emacs

main () {
    DOCUMENTMASTER="$1"
    zathura "$@"
    # TODO: want something that does not raise
    sleep 0.2
    WINNAME=$(wmctrl -lx | awk '{print $1 " " $3 " " $5}' | grep zathura.Zathura | grep -- "$DOCUMENTMASTER" | awk '{print $3}')
    wmctrl -a "$WINNAME"
}
main "$@"

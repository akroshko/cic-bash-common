#!/bin/bash

main () {
    WINDOWCLASS="$1"
    CURRENTWINDOWID=$(xprop -root | grep ^_NET_ACTIVE_WINDOW | awk '{print $5}' | sed -e 's/,//' -e 's/0x0*//g')
    echo "$CURRENTWINDOWID"
    local WMLIST=$(wmctrl -lx)
    local WMLISTCLASS=$(grep "$WINDOWCLASS" <<< "$WMLIST")
    local WMLISTCLASS_LINE_NUMBERS=$(grep --line-number '.*' <<< "$WMLISTCLASS")
    printf "$WMLISTCLASS_LINE_NUMBERS"
    printf "\n"
    local CURRENT_WINDOW_LINE_NUMBER=$(grep "$CURRENTWINDOWID" <<< "$WMLISTCLASS_LINE_NUMBERS")
    local CURRENT_WINDOW_LINE_NUMBER=$(sed -n 's/.*\(^[0-9]*\).*/\1/p' <<< "$CURRENT_WINDOW_LINE_NUMBER")
    echo "Current: $CURRENT_WINDOW_LINE_NUMBER"
    # TODO: need total lines
    local LAST_LINE_NUMBER=$(tail -n 1 <<< "$WMLISTCLASS_LINE_NUMBERS")
    echo "$LAST_LINE_NUMBER"
    local LAST_LINE_NUMBER=$(sed -n 's/.*\(^[0-9]*\).*/\1/p' <<< "$LAST_LINE_NUMBER")
    echo "Last: $LAST_LINE_NUMBER"
    if [[ -n "$CURRENT_WINDOW_LINE_NUMBER" && "$LAST_LINE_NUMBER" ]]; then
        local NEXT_LINE_NUMBER=$(( "$CURRENT_WINDOW_LINE_NUMBER" % "$LAST_LINE_NUMBER" + 1 ))
        local NEXT_WINDOW_ID=$(sed -n "$NEXT_LINE_NUMBER"'p' <<< "$WMLISTCLASS")
        local NEXT_WINDOW_ID=$(awk '{print $1}' <<< "$NEXT_WINDOW_ID")
        echo "Next: $NEXT_WINDOW_ID"
    else
        echo "No next window ID!"
    fi
    # are we actually on a the selected window class id
    if wmctrl -lx | awk '{print $1 " " $3}' | sed -e 's/0x0*//g' | grep -- "$CURRENTWINDOWID.*$WINDOWCLASS"; then
        # am I on the current line
        wmctrl -i -a "$NEXT_WINDOW_ID"
    else
        # only save if we are not on the desired window class
        "$HOME/bin/x11_save_focused_window.sh"
        # switch to whatever wmctrl wants
        wmctrl -x -a "$WINDOWCLASS"
    fi
}

main "$@"

#!/bin/bash
if [[ -n "$1" ]]; then
    ALREADYFIXED=
    if ps -elf | grep "xpdf.*$2" | grep -v grep | grep -v "xpdf-local.sh" >/dev/null; then
        ALREADYFIXED=1
        xpdf -remote "$2" -exec closeOutline
        xpdf -remote "$2" -exec singlePageMode
        xpdf -remote "$2" -exec zoomFitPage
    fi
    xpdf "$@" &
    # TODO: wait better
    sleep 3.0
    # # fix after if first time
    if [[ -z $ALREADYFIXED ]]; then
        xpdf -remote "$2" -exec closeOutline
        xpdf -remote "$2" -exec singlePageMode
        xpdf -remote "$2" -exec zoomFitPage
    fi
else
    echo "No input!!!"
fi

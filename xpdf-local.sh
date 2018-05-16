#!/bin/bash
if [[ -n "$1" ]]; then
    if ps -elf | grep -- "xpdf.*$2" | grep -v "xpdf-local.sh" | grep -v grep >/dev/null; then
        ALREADYFIXED=1
        # put in background to make sure these finish
        xpdf -remote "$2" -exec closeOutline &
        sleep 0.1
        xpdf -remote "$2" -exec singlePageMode &
        sleep 0.1
        xpdf -remote "$2" -exec zoomFitPage &
        sleep 0.1
        xpdf "$@" -raise &
    else
        xpdf "$@" &
        sleep 3.0
        xpdf -remote "$2" -exec closeOutline &
        sleep 0.1
        xpdf -remote "$2" -exec singlePageMode &
        sleep 0.1
        xpdf -remote "$2" -exec zoomFitPage &
        sleep 0.1
    fi
else
    echo "No input!!!"
fi

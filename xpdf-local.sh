#!/bin/bash
if [[ -n "$1" ]]; then
    if ps -elf | grep -- "[x]pdf.*$2" | grep -v "[x]pdf-local.sh" >/dev/null; then
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

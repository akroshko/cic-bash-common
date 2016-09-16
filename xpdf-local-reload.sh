#!/bin/bash
# does not do anything if xpdf is not open
if [[ -n "$1" ]]; then
    if ps -elf | grep "xpdf.*$2" | grep -v "xpdf-local-reload.sh" | grep -v grep >/dev/null; then
        # put in background to make sure these finish
        xpdf -remote "$2" -exec closeOutline &
        sleep 0.1
        xpdf -remote "$2" -exec singlePageMode &
        sleep 0.1
        xpdf -remote "$2" -exec zoomFitPage &
        sleep 0.1
        xpdf "$@" -raise &
        exit 0
    fi
    exit 1
else
    echo "No input!!!"
    exit 1
fi

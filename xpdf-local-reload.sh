#!/bin/bash
# does not do anything if xpdf is not open
if [[ -n "$1" ]]; then
    # TODO: fix up this grep so I check for something valid
    if ps -elf | grep -- "[x]pdf.*$2" | grep -v "[x]pdf-local-reload.sh" >/dev/null; then
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

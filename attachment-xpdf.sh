#!/bin/bash

source ~/.bash_libenv

main () {
    pdftk "${PWD}"/"$1" cat "$2" output ${HOME}/current-attachment/$(date-time-stamp).pdf
    # TODO: convert to image
}
main "$@"

#!/bin/bash
# this is an alternate emacsclient, except it simply notifies of the failure,
# having a seperate script avoids opening Emacs without the server
notify-send 'emacsclient failed to start!!!' -t 5000

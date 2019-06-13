#!/bin/bash
(nohup rxvt-unicode -name -rxvt-below --geometry +0+0 -e bash -i -c "source ~/.profile" &)

#!/bin/bash
launch-emacsclient noframe --eval "(message \"mouseclick.sh $1, $2, $3, $4\")"
xcoord=$(printf "%.0f\n" "$3")
ycoord=$(printf "%.0f\n" "$4")
# 72*11.5=828.0, however, assume margines?
# a bit off, but assume 8.5x11 paper
bname=`basename $1 .pdf`
pagesize=$(pdfinfo "${bname}.pdf" | grep "Page size:" | sed -e 's/[^0-9 ]//g' | awk '{print $2}')
launch-emacsclient noframe --eval "(message \"Pagesize: $pagesize\")"
ycoord=$(( $pagesize - $ycoord ))
mypwd=`pwd`
launch-emacsclient noframe --eval "(message \"$mypwd $bname $xcoord $ycoord\")"
# now use synctex
# want only the last line, sometimes synctex will put out two lines
theline=$(synctex edit -o "$2:$xcoord:$ycoord:$bname" | grep "Line:" | sed -e 's/Line://' | head -n 1)
launch-emacsclient noframe --eval "(message \"$theline\")"
# TODO: check if theline is a number
launch-emacsclient noframe --eval "(progn (switch-to-buffer \"$bname.tex\") (goto-char (point-min)) (forward-line (1- $theline)) (recenter-top-bottom))"
launch-emacsclient noframe --eval "(message \"Inverse search complete!!!\")"'

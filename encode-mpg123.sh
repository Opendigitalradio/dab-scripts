#!/bin/bash
#
# Encode programme using mpg123
#
# Status: Experimental

URL=$1
ID=$2
DST=$4

BITRATE=80
RATE=32000

if [[ "$DST" == "" ]]
then
    echo "Usage $0 url id destination"
    exit 1
fi

while true
do

    mpg123 -r $RATE -s $URL | \
        dabplus-enc -i /dev/stdin -b $BITRATE -r $RATE -f raw -a -o $DST

    R=$?

    MAILTO=$(cat site/mail-warning.txt)

    if [[ "$MAILTO" != "" ]] ; then
        NOW=$(date)

        mail -s "Encoder $ID restart $URL" $MAILTO << EOF
The encoder id:$ID
encoding $URL -> $DST with mpg123 was restarted at
$NOW

The return code was $R

EOF
    fi

    sleep 5
done


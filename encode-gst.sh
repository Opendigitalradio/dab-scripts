#!/bin/bash
#
# Encode one programme using gstreamer.
#
# Status: Experimental

URL=$1
ID=$2
DST=$3

QUEUEDELAY=400000 #400ms

BITRATE=80
RATE=32000

if [[ "$DST" == "" ]]
then
    echo "Usage $0 url id destination"
    exit 1
fi

while true
do

    gst-launch -q \
            uridecodebin uri=$URL ! \
            queue "max-size-time=$QUEUEDELAY" ! \
            audioresample quality=8 ! \
            audioconvert ! \
            audio/x-raw-int, "rate=$RATE,format=S16LE,channels=2" ! \
            filesink location="/dev/stdout" | \
        dabplus-enc -i /dev/stdin -b $BITRATE -r $RATE -f raw -a -o $DST

    R=$?

    NOW=$(date)

    mail -s "Encoder $ID restart $URL" matthias+odrge1@mpb.li << EOF
The encoder id:$ID
encoding $URL -> $DST with gstreamer was restarted at
$NOW

The return code was $R

EOF

    sleep 5
done

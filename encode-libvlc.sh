#!/bin/bash
#
# Encode programme using libVLC input from
# dabplus-enc or toolame
#
# monitor processes, and restart if necessary
# Optionally send an email when restart happens

printerr() {
    echo -e "\033[01;31m$1\033[0m"
    logger -p local0.error -t "$ID" "$1"
}

printmsg() {
    echo -e "\033[01;32m$1\033[0m"
    logger -p local0.notice -t "$ID" "$1"
}

set -u

# check number of arguments
if [[ "$#" -lt 3 ]] ; then
    echo "Usage $0 url destination [encoder]"
    echo "Encoder shall be 'dabplus-enc' or 'toolame'"
    exit 1
fi

URL=$1
ID=$2
DST=$3

if [[ "$#" -eq 4 ]] ; then
    ENC=$4
else
    ENC="dabplus-enc"
fi

BITRATE=80

running=1

encoderpid=0

# The trap for Ctrl-C
sigint_trap() {
    printerr "Got Ctrl-C, killing mplayer and encoder"
    running=0

    if [[ "$encoderpid" != "0" ]] ; then
        kill -TERM $encoderpid
        sleep 2
        kill -KILL $encoderpid
    fi

    printmsg "quitting"
    exit
}

trap sigint_trap SIGTERM
trap sigint_trap SIGINT

while [[ "$running" == "1" ]]
do

    printmsg "Launching encoder"
    if [[ "$ENC" == "dabplus-enc" ]] ; then
        dabplus-enc -v "$URL" -b $BITRATE -r 32000 -o "$DST" -l &
        encoderpid=$!
    elif [[ "$ENC" == "toolame" ]] ; then
        toolame -V -s 48 -L -b $BITRATE "$URL" "$DST" &
        encoderpid=$!
    fi
    printerr "Detected crash of encoder!"

    sleep 5

    checkloop=1
    while [[ "$checkloop" == "1" ]]
    do
        sleep 2

        kill -s 0 $encoderpid
        if [[ "$?" != "0" ]] ; then
            printerr "the encoder died"

            encoderpid=0
            checkloop=0
        fi
    done

    MAILTO=$(cat site/mail-warning.txt)

    if [[ "$MAILTO" != "" ]] ; then
        NOW=$(date)

        mail -s "Encoder $ID restart $URL" "$MAILTO" << EOF
The encoder id:$ID
encoding $URL -> $DST using encode-libvlc was restarted at
$NOW

EOF

    fi
    sleep 5

done


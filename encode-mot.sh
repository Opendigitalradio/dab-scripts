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
    echo "Usage $0 id options"
    exit 1
fi

ID=$1
shift 2

OPTIONS=$@

running=1

encoderpid=0

# The trap for Ctrl-C
sigint_trap() {
    printerr "Got Ctrl-C, killing mot-encoder"
    running=0

    if [[ "$encoderpid" != "0" ]] ; then
        kill -TERM $encoderpid
    fi

    printmsg "quitting"
    exit
}

trap sigint_trap SIGTERM
trap sigint_trap SIGINT

while [[ "$running" == "1" ]]
do

    printmsg "Launching mot-encoder"
        mot-encoder $OPTIONS &
        encoderpid=$!
    printerr "Detected crash of encoder!"

    sleep 5

    checkloop=1
    while [[ "$checkloop" == "1" ]]
    do
        sleep 2

        kill -s 0 $encoderpid
        if [[ "$?" != "0" ]] ; then
            printerr "the mot-encoder died"

            encoderpid=0
            checkloop=0
        fi
    done

    MAILTO=$(cat ./mail-warning.txt)

    if [[ "$MAILTO" != "" ]] ; then
        NOW=$(date)

        mail -s "MOT Encoder $ID restart $URL" "$MAILTO" << EOF
The encoder id:$ID
encoding using mot-encoder was restarted at
$NOW

EOF

    fi
    sleep 5

done


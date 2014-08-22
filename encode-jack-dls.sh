#!/bin/bash
#
# Encode programme using mplayer, connect through JACK
# to dabplus-enc or toolame
#
# Read webstream from URL using mplayer
# Launch dabplus-enc or toolame encoder
# connect both through JACK
# monitor processes, and restart if necessary
# Optionally send an email when restart happens
#
# Extract ICY Text from stream and use it for DLS

printerr() {
    echo -e "\033[01;31m$1\033[0m"
}

printmsg() {
    echo -e "\033[01;32m$1\033[0m"
}

set -u

# check number of arguments
if [[ "$#" < 3 ]] ; then
    echo "Usage $0 url jack-id destination [volume] [encoder]"
    echo "The volume setting is optional"
    exit 1
fi

if [[ "$#" > 2 ]] ; then
    URL=$1
    ID=$2
    DST=$3
fi

if [[ "$#" == 4 ]] ; then
    VOL=$4
    ENC="dabplus-enc"
elif [[ "$#" == 5 ]] ; then
    VOL=$4
    ENC=$5
else
    VOL="0"
    ENC="dabplus-enc"
fi


BITRATE=80
RATE=32 #kHz

if [[ "$ENC" == "toolame" && "RATE" == "32" ]] ; then
    echo "32kHz not supported for toolame"
    exit 1
fi

DLSDIR=site/dls
SLIDEDIR=site/slide

encoderalive=0
mplayerpid=0
encoderpid=0
motencoderpid=0
running=1

mplayer_ok=0
encoder_ok=0

# The trap for Ctrl-C
sigint_trap() {
    printerr "Got Ctrl-C, killing mplayer and encoder"
    running=0

    if [[ "$mplayerpid" != "0" ]] ; then
        kill -TERM $mplayerpid
        sleep 2
        kill -KILL $mplayerpid
    fi

    if [[ "$encoderpid" != "0" ]] ; then
        kill -TERM $encoderpid
        sleep 2
        kill -KILL $encoderpid
    fi

    if [[ "$motencoderpid" != "0" ]] ; then
        kill -TERM $motencoderpid
        sleep 2
        kill -KILL $motencoderpid
    fi

    printmsg "Goodbye"
    exit
}

trap sigint_trap SIGTERM
trap sigint_trap SIGINT

while [[ "$running" == "1" ]]
do
    if [[ "$mplayerpid" == "0" ]] ; then
        if [[ "$VOL" == "0" ]] ; then
            mplayer -quiet -af resample=${RATE}000:0:2 -ao jack:name=$ID $URL | \
                ./icy-info.py $DLSDIR/${ID}.dls $DLSDIR/${ID}-default.dls &
            mplayerpid=$!
        else
            mplayer -quiet -af resample=${RATE}000:0:2 -af volume=$VOL -ao jack:name=$ID $URL | \
                ./icy-info.py $DLSDIR/${ID}.dls $DLSDIR/${ID}-default.dls &
            mplayerpid=$!
        fi

        printmsg "Started mplayer with pid $mplayerpid"

        # give some time to mplayer to set up and
        # wait until port becomes visible
        timeout=10

        while [[ "$mplayer_ok" == "0" ]]
        do
            printmsg "Waiting for mplayer to connect to jack ($timeout)"
            sleep 1
            mplayer_ok=$(jack_lsp $ID:out_0 | wc -l)

            timeout=$(( $timeout - 1 ))

            if [[ "$timeout" == "0" ]] ; then
                printerr "mplayer doesn't connect to jack !"
                kill $mplayerpid
                break
            fi
        done
    else
        printmsg "No need to start mplayer: $mplayerpid"
    fi

    if [[ "$mplayer_ok" == "1" && "$encoder_ok" == "0" ]] ; then
        if [[ "$ENC" == "dabplus-enc" ]] ; then
            dabplus-enc -j ${ID}enc -l \
                -p 34 -P $DLSDIR/${ID}.pad \
                -b $BITRATE -r ${RATE}000 -f raw -a -o $DST &
            encoderpid=$!
        elif [[ "$ENC" == "toolame" ]] ; then
            toolame -b $BITRATE -s $RATE \
                -p 34 -P $DLSDIR/${ID}.pad \
                -j ${ID}enc $DST &
            encoderpid=$!
        fi

        # give some time to the encoder to set up and
        # wait until port becomes visible
        timeout=10

        encoder_connected=0

        while [[ "$encoder_connected" == "0" ]]
        do
            printmsg "Waiting for encoder to connect to jack ($timeout)"
            sleep 1
            encoder_connected=$(jack_lsp ${ID}enc:input0 | wc -l)

            timeout=$(( $timeout - 1))

            if [[ "$timeout" == "0" ]] ; then
                printerr "encoder doesn't connect to jack !"
                kill $encoderpid
                break
            fi
        done

        if [[ "$encoder_connected" == "1" ]] ; then
            jack_connect ${ID}:out_0 ${ID}enc:input0 && \
            jack_connect ${ID}:out_1 ${ID}enc:input1
            connect_ret=$?

            if [[ "$connect_ret" == "0" ]] ; then
                encoder_ok=1
            else
                encoder_ok=0
            fi

            if [[ "$encoder_ok" == "1" ]] ; then
                printmsg "Started encoder with pid $encoderpid"
            else
                if [[ "$encoderpid" != "0" ]] ; then
                    kill -TERM $encoderpid
                fi
            fi
        fi
    fi

    if [[ "$encoder_ok" == "1" && "$motencoderpid" == "0" ]] ; then
        # Check if the slides folder exists, and start mot-encoder accordingly
        if [[ -d "$SLIDEDIR/$ID" ]] ; then
            mot-encoder -o $DLSDIR/${ID}.pad -t $DLSDIR/${ID}.dls -p 34 -v \
                -e -d $SLIDEDIR/${ID} &
            motencoderpid=$!
        else
            mot-encoder -o $DLSDIR/${ID}.pad -t $DLSDIR/${ID}.dls -p 34 -v &
            motencoderpid=$!
        fi

        printmsg "Started mot-encoder with pid $encoderpid"
    fi


    sleep 5

    checkloop=1
    while [[ "$checkloop" == "1" ]]
    do
        sleep 2

        kill -s 0 $mplayerpid
        if [[ "$?" != "0" ]] ; then
            # mplayer died
            # we must kill jack-stdout, because we cannot reconnect it
            # to a new mplayer, since we do not know the jack-stdout name.
            # And it has no cmdline option to set one, Rrrrongntudtjuuu!
            if [[ "$encoderpid" != "0" ]] ; then
                kill -TERM $encoderpid
            fi

            if [[ "$motencoderpid" != "0" ]] ; then
                kill -TERM $motencoderpid
            fi

            # mark as dead
            mplayerpid=0
            mplayer_ok=0
            encoderpid=0
            encoder_ok=0
            motencoderpid=0

            checkloop=0

            printerr "Mplayer died"
        fi

        if [[ "$encoderpid" != "0" ]] ; then
            kill -s 0 $encoderpid
            if [[ "$?" != "0" ]] ; then
                # the encoder died,
                # no need to kill the mplayer, we can reconnect to it

                if [[ "$motencoderpid" != "0" ]] ; then
                    kill -TERM $motencoderpid
                fi

                motencoderpid=0
                encoderpid=0
                encoder_ok=0

                checkloop=0

                printerr "Encoder died"
            fi
        fi

        if [[ "$motencoderpid" != "0" ]] ; then
            kill -s 0 $motencoderpid
            if [[ "$?" != "0" ]] ; then
                # mot-encoder died
                # let's try restarting it

                motencoderpid=0

                checkloop=0

                printerr "mot-encoder died"
            fi
        fi
    done

    MAILTO=$(cat site/mail-warning.txt)

    if [[ "$MAILTO" != "" ]] ; then
        NOW=$(date)

        mail -s "Encoder $ID restart $URL" $MAILTO << EOF
The encoder id:$ID
encoding $URL -> $DST using encode-jack-dls was restarted at
$NOW

mplayer ok? $mplayer_ok

EOF

    fi
    sleep 5

done


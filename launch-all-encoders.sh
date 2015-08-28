#!/bin/bash
# launch each encoder in its own screen window

set -e

if [ -f ./configuration.sh ]
then

    source ./configuration.sh

    for radio in ${all_radios[*]}
    do
        echo "Launching $radio encoder"
        screen -t "Audio Encoder $radio" ./radio.sh "$radio"
        sleep 0.4
    done

    for mot in ${all_mot[*]}
    do
        echo "Launching $mot mot-encoder"
        screen -t "MOT Encoder $mot" ./mot.sh "$mot"
	sleep 0.4
    done
else
    echo "Error: No site configuration available!"
    exit 1
fi


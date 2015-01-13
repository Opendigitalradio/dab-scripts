#!/bin/bash
# launch each encoder in its own screen window

set -e

if [ -f site/configuration.sh ]
then

    source site/configuration.sh

    for radio in ${all_radios[*]}
    do
        echo "Launching $radio encoder"
        screen -t "$radio" ./radio.sh "$radio"
        sleep 0.4
    done

else
    echo "Error: No site configuration available!"
    exit 1
fi


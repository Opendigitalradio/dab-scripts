#!/bin/bash
# launch each encoder in its own screen window

if [ -f site/configuration.sh ]
then

    source site/configuration.sh

    for radio in ${all_radios[*]}
    do
        screen -t $radio ./radio $radio
        sleep 0.4
    done

else
    echo "Error: No site configuration available!"
    exit 1
fi


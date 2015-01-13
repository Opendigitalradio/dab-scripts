#!/bin/bash
#
# Launch the multiplexer and the modulator

if [[ -e site/multiplex.mux && -e site/mod.ini && -e site/mail-warning.txt ]]
then

    while true
    do
        odr-dabmux -e site/multiplex.mux | sudo odr-dabmod -C site/mod.ini
        R=$?

        MAILTO=$(cat site/mail-warning.txt)

        if [[ "$MAILTO" != "" ]] ; then
            NOW=$(date)
            mail -s "MUX and MOD restart" "$MAILTO" << EOF
The mux and mod were restarted at
$NOW

The return code was $R

EOF

        fi

        sleep 15
    done
else
    echo "Incomplete site configuration !"
    echo "Check that the site/ folder exists"
    exit 1
fi


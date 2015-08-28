#!/bin/bash
#
# Start the mot-encoder for the radio

set -e

source ./configuration.sh

printerr() {
    echo -e "\033[01;31m$1\033[0m"
}

printmsg() {
    echo -e "\033[01;32m$1\033[0m"
}

script_pid=0
sigint_trap() {
    printerr "Got Ctrl-C, killing radio encoder script"
    if [[ "$script_pid" != "0" ]] ; then
        kill $script_pid
        script_pid=0
        wait
    fi
}

set -e

# check number of arguments
if [[ "$#" -lt 1 ]] ; then
    echo "Usage $0 radio-id"
    echo "You must specify which radio to start"
    exit 1
fi

RADIO=$1

if [ "${mot[$RADIO]+_}" ] ; then
    COMMAND=${mot[$RADIO]}

    trap sigint_trap SIGINT

    # execute script
    $COMMAND &
    script_pid=$!
    wait
else
    echo "Radio $RADIO not defined in configuration"
    exit 1
fi


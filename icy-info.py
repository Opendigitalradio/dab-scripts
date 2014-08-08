#!/usr/bin/python2
#
# This script parses the mplayer standard output and
# extracts ICY info for the mot-encoder.
#
# Usage:
# mplayer <blablabla> | icy-info.py file.dls file-with-default.dls
#
# the file-with-default.dls contains DLS text to be sent when there
# is no ICY info

import re
import select
import sys
import time

re_icy = re.compile(r"""ICY Info: StreamTitle='([^']*)'.*""")

if len(sys.argv) < 3:
    print("Please specify dls output file, and file containing default text")
    sys.exit(1)

dls_file = sys.argv[1]

default_textfile = sys.argv[2]

def new_dlstext(text):
    if text.strip() == "":
        try:
            fd = open(default_textfile, "r")
            text = fd.read().strip()
            fd.close()
        except Exception as e:
            print("Could not read default text from {}: {}".format(default_textfile, e))

    print("New Text: {}".format(text))

    fd = open(dls_file, "w")
    fd.write(text)
    fd.close()

wait_timeout = 5
nodls_timeout = 0


while True:
    # readline is blocking, therefore we cannot send a default text
    # after some timeout
    new_data = sys.stdin.readline()
    if not new_data:
        break

    match = re_icy.match(new_data)

    if match:
        artist_title = match.groups()[0]
        new_dlstext(artist_title)
    else:
        print("{}".format(new_data.strip()))

if False:
    # The select call creates a one ICY delay, and it's not clear why...
    while True:
        rfds, wfds, efds = select.select( [sys.stdin], [], [], wait_timeout)

        if rfds:
            # new data available on stdin
            print("SELECT !")
            new_data = sys.stdin.readline()
            print("DATA ! {}".format(new_data))

            if not new_data:
                break

            match = re_icy.match(new_data)

            if match:
                artist_title = match.groups()[0]
                new_dlstext(artist_title)
            else:
                print("{}".format(new_data.strip()))

        else:
            # timeout reading stdin
            nodls_timeout += 1

            if nodls_timeout == 100:
                new_dlstext("")
                nodls_timeout = 0

        time.sleep(.1)



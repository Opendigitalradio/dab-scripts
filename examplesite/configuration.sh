# Configuration file for the encoder scripts

all_radios=(
    "radio1"
    "radio2" )

# declare radios to be an associative array, DO NOT REMOVE
declare -A radios

# for each radio, write here the full encoder command.
# encode-jack needs:
#  URL ID dabmux-URL [amplitude correction]
radios[radio1]="./encode-libvlc.sh http://fbpc5.epfl.ch:8000/fb_192 radio1 tcp://localhost:9001"

# Attenuate radio2 by 3dB
radios[radio2]="./encode-libvlc.sh http://mp3lg.tdf-cdn.com/fip/all/fiphautdebit.mp3 radio2 tcp://localhost:9002 toolame -b 128 -s 48 -m j -y 2 -L"


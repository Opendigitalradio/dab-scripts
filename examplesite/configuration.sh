# Configuration file for the encoder scripts

all_radios=(
    "radio1"
    "radio2" )

# declare radios to be an associative array, DO NOT REMOVE
declare -A radios

# for each radio, write here the full encoder command.
# encode-jack needs:
#  URL ID dabmux-URL [amplitude correction]
radios[radio1]="./encode-jack.sh http://fbpc5.epfl.ch:8000/fb_192 radio1 tcp://localhost:9001"

# Attenuate radio2 by 3dB
radios[radio2]="./encode-jack.sh http://91.121.151.197:8016 radio2 tcp://localhost:9002"


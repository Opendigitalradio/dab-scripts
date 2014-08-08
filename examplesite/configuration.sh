# Configuration file for the encoder scripts

all_radios=(
    "radio1"
    "radio2" )

# for each radio, write here the full encoder command.
# encode-jack needs:
#  URL ID dabmux-URL [amplitude correction]
radios[radio1]="./encode-jack.sh http://radio1streamurl.example.com radio1 tcp://localhost:9000"

# Attenuate radio2 by 3dB
radios[radio2]="./encode-jack.sh http://radio2streamurl.example.com radio2 tcp://localhost:9001 -3"


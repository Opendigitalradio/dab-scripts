# Configuration file for the encoder scripts

all_radios=("radio1" "radio2" "radio3")
all_mot=("radio1" "radio3")

# declare radios to be an associative array, DO NOT REMOVE
declare -A radios
declare -A mot

# for each radio, write here the full encoder command.
# encode-jack needs:
#  URL ID dabmux-URL [amplitude correction]

# radio1
radios[radio1]="./encode-libvlc.sh http://radio1.aac Radio1 tcp://localhost:9001 toolame -b 128 -s 48 -m j -y 2 -L -W dls/radio1.txt -p 6 -P dls/radio1.dls"
mot[radio]="./encode-mot.sh Radio1 --pad 6 --remove-dls --dls dls/radio1.txt --output dls/radio1.dls"

# radio2
radios[radio2]="./encode-libvlc.sh http://radio2.aac Radio2 tcp://localhost:9002 toolame -b 128 -s 48 -m j -y 2 -L"

# radio3
radios[radio3]="./encode-libvlc.sh http://radio3.aac Radio3 tcp://localhost:9003 toolame -b 128 -s 48 -m j -y 2 -L -W dls/radio3.txt -p 6 -P dls/radio3.dls"
mot[radio3]="./encode-mot.sh Radio3 --pad 6 --remove-dls --dls dls/radio3.txt --output dls/radio3.dls"

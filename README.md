# Table of contents
- [Introduction](#introduction)
- [ODR-mmbTools components](#odr-mmbtools-components)
- [Repository structure](#repository-structure)
- [Operations](#operations)
- [Configuration](#configuration)

# Introduction
The goal of this repository is to provide a:
- Debian shell script that installs or removes the:
    - Main components of the odr-mmbTools suite used in a transmission chain
    - [Supervisor](http://supervisord.org/) package
- Simple yet functional dab configuration sample that you can adapt to your needs

# ODR-mmbTools components
- Encoder-manager: provides a web interface to manage audio streams and their related PAD data
- PAD encoder: one per radio station being broadcasted. Gathers radio-related data (ex: artist, song, slogan, logo) and shares it with the related audio encoder
- Audio encoder: one per radio station being broadcasted. Receives the radio web stream, combines it with the data from the PAD encoder and shares it with the multiplexer
- Multiplexer: packs the data from audio encoders into a DAB/DAB+ ensemble and shares it with a modulator
- Multiplex-manager: provides a web interface to view and modify some multiplex parameters
- Modulator: creates a modulation with the multiplexer data and sends it to a transmitter

# Repository structure
## install
This folder contains the installation/removal shell script. Please check the **README.md** file inside this directory to run the installation shell script
## config
This folder contains the sample configuration files. If you use the provided installation script, it will be copied on your system:
- config/odr-dabmod.ini: ODR-DabMod configuration
- config/odr-dabmux.info: ODR-DabMux configuration
- config/supervisor/ODR-encoders.conf: supervisor configuration file for all encoders (audio + PAD)
- config/supervisor/ODR-encoders.conf: supervisor configuration file for all other odr-mmbTools excluding the encoders
- config/mot/: folder with the dls and slide files

# Operations
In this section:
- **server** relates to the host where you installed the odr-mmbTools and the configuration files
- **client** relates to any computer (including the server)

After you ran the installation script on the server, point the web browser on the client to the **Supervisor web interface** on the host (http://server_address:8001). The default user name is **odr** and the default password is **odr**. Please note that this user name is not a system user profile.

The supervisor web interface provides a graphical interface to start or stop each components of the DAB/DAB+ transmission chain: modulator, multiplexer, encoders (audio & data), encoder-manager and multiplex-manager.

# Configuration
## User access
### Supervisor web interface
If you want to change the default user name and/or user password authorized to access the Supervisor web interface, then apply the following commands:
```
# Change the user name
sudo sed -e 's/^username = odr/^username = whatever_user/' -i /etc/supervisor/supervisord.conf

# Change the user password
sudo sed -e 's/^password = odr/^password = whatever_password/' -i /etc/supervisor/supervisord.conf
```
Please note that *whatever_user* is not related to any linux profiles

### Encoder-manager web interface
If you want to change the default user profile and/or user password authorized to access the Encoder-manager web interface, then apply the following commands:
```
# Change the user name
sed -e 's/"username": "odr"/"username": "whatever_user"/' -i $HOME/config/encodermanager.json

# Change the user password
sed -e 's/"password": "odr"/"password": "whatever_password"/' -i $HOME/config/encodermanager.json
```
Please note that *whatever_user* is not related to any linux profiles

## RF Transmission
### Improve the transmitted RF spectrum
If your hardware/virtual host is not powerful enough, then you should set the following 2 parameters in the $HOME/config/odr-dabmod.ini file to less stringent value:
- modulator rate=2048000
- firfilter enabled=0

### Change the transmission channel
If channel 5A is being used in your area, you can easily switch to a [new transmission channel](http://www.wohnort.org/config/freqs.html) by applying the following command:
```
sed -e 's/^channel=5A/^channel=a_free_channel_in_your_area/' -i $HOME/config/odr-dabmod.ini
```

### Change the SOAPYSDR-compatible device
The modulator sample configuration file is setup for a [HackRF One](https://greatscottgadgets.com/hackrf/one/) using the [SoapySDR](https://github.com/pothosware/SoapySDR/wiki) interface.

If you need to transmit with another SoapySDR-compatible transceiver card, then apply one of the following commands:
```
# LimeSDR
sed -e 's/^device=driver=hackrf/^device=driver=lime/' -i $HOME/config/odr-dabmod.ini

# PlutoSDR
sed -e 's/^device=driver=hackrf/^device=driver=plutosdr/' -i $HOME/config/odr-dabmod.ini

# Blade RF
sed -e 's/^device=driver=hackrf/^device=driver=bladerf/' -i $HOME/config/odr-dabmod.ini
```

### Change the transmission power setting
We recommend that you check the documentation of the SoapySDR module for your device for the field **txgain** in file $HOME/config/odr-dabmod.ini

## Broadcast programs
### Change the name of the multiplex
If you want to change the name of the multiplex, then change the label and shortlabel values within the **ensemble** block in file $HOME/config/odr-dabmux.info

### Change and/or add new programs
If your server is powerful enough, then you can add more services/sub-channels/components
1. Start job **10-EncoderManager** from the Supervisor web access
1. Point the web browser of the client to the **Encoder Manager web interface** on the host (http://server_address:8003). You can use the excellent [radio browser directory](https://www.radio-browser.info) to identify the url of the radio audio stream
1. Modify file $HOME/config/odr-dabmux.info and adapt the services, subchannels and components in relation with the changes you made with the Encoder-Manager. You should use the values mentionned in the [official ETSI TS 101 756 document](https://www.etsi.org/deliver/etsi_ts/101700_101799/101756/02.02.01_60/ts_101756v020201p.pdf).

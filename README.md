ODR-mmbTools scripts for 24/7 operation
=======================================

This repository contains a set of scripts that can be used for
running the ODR-mmbTools in a production environment, where
failure resilience is important.

Concept
-------

The scripts themselves, all located in this folder, are independent
of the configuration of the transmission. All configuration is
in a separate folder called 'site'. 'examplesite' contains a sample
configuration you can adapt.

These scripts assume that all programme streams to be included in
the multiplex are mp3 webstreams. For each programme, a URL has to
be specified.

The scripts are designed to be failure-resilient: in case and encoder
or a web-stream decoder crashes, an email is sent to the operator, a
log message is written to syslog, and the encoding chain is restarted.

Prerequisites
-------------
You need to have a working ODR-DabMux and ODR-DabMod configuration to
use these scripts. Also several audio-related tools are necessary
(mplayer, gstreamer, etc.)

The ICY-Text to DLS script requires python.

Folder structure
----------------

The root folder contains the scripts described below.

The site/ folder contains the site configuration.
The site/dls folder contains the files needed for communication between
the scripts for the insertion of DLS, and the site/slide contains slides
to be transmitted.

site/configuration.sh lists all the programmes to be transmitted.

site/multiplex.mux contains the ODR-DabMux configuration. site/mod.ini is used
as configuration for ODR-DabMod.

site/filtertaps.txt contains the ODR-DabMod FIRFilter taps.

site/mail-warning.txt is either empty, if no warning mails should be sent by the
script, or a valid email address to send the warning to.

The site/dls folder must exist, and can contain default DLS text files for the
different programmes.

The site/slide folder is optional, and must contain one folder for each programme,
named after its ID, into which you can place slides to be transmitted.

How to get started
------------------

The examplesite/ folder should be taken as a template to create a new site, it
contains all needed files.

 * Create a copy of it, and call it *site*.
 * Modify and adapt all configuration files presented above.
 * Start a GNU Screen session.
 * Launch JACK (see below)
 * Start ODR-DabMux and ODR-DabMod using *start-mux-mod.sh*
 * Start one encoder using *radio.sh ID* or all encoders with
   *launch-all-encoders.sh*

Scripts
-------

*start-mux-mod.sh* starts ODR-DabMux and ODR-DabMod with the configuration
given in site/multiplex.mux and site/mod.ini

*radio.sh* starts one mplayer and fdk-aac-dabplus encoder for the radio
programme whose identification is set in site/configuration.sh. This script
will automatically restart the encoder if there is a failure.

The *encode-XYZ.sh* scripts contain all the logic for failure resilience,
and use different players to read the stream.

*encode-libvlc.sh* is the newest addition: it launches an encoder using the
integrated libVLC input that can directly connect to a web-stream. There is
no DLS support yet.

*encode-jack.sh* is the best supported script of all these. It extracts
ICY-Text and launches the mot-encoder to insert DLS and optionally slides.
 It needs a running JACK daemon to work, which should be started with

   jackd -d dummy -r 32000

*launch-all-encoders.sh* and *kill-all-encoders.sh* can start and stop all
configured encoders, and are meant to be used inside a GNU Screen session. For
each encoder, a new GNU Screen window is created.

*icy-info.py* is a helper script that converts the webstream ICY Text into DLS
for the mot-encoder. Do not run it directly, it is used by *encode-jack.sh*.


Additional remarks
------------------

For a rate of 48kHz, the RATE parameters in the *encode-XYZ.sh* script must be
changed.


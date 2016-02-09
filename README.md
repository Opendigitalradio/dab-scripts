ODR-mmbTools scripts for 24/7 operation
=======================================
version : radioHack2016


Prerequisites
-------------
You need to have a working ODR-DabMux, ODR-DabMod, fdk-aac-dabplus and/or toolame-dab configuration to
use these scripts. Also supervisor is now needed. (apt-get install supervisor)


Folder structure
----------------

The 'config' folder contains all needed configuration file and needed to be moved into /home/odr/ folder.

  * config/mod.conf : contains mod configuration
  * config/mux.conf : contains mux configuration
  * config/supervisor/ : contains all supervisor configuration file.
  * config/mot/ : contains all dls and sls file. You need to create FIFO FILE with mkfifo for eatch radio (mkfifo /home/odr/config/mot/f3.pad)


About encoder and mot-encoder
-----------------

Encoder (toolame-dab or dabplus-enc) write ICY-text into a text file. You need to create this file at first for each radio :
  * touch /home/odr/config/mot/f3.txt

mot-encoder read ICY-text information from previous text file and write into pad file. This pad file need to be a FIFO and you need to create it for each radio :
  * mkfifo /home/odr/config/mot/f3.pad

If you use Slide Show, you can put your image into the directory under mot folder corresponding to the radio (example: /home/odr/config/mot/f3/)


About supervisor
----------------

You need to create sym link into /etc/supervisor/conf.d/ for eatch radio configuration file and call supervisorctl to reread and update configuration.
Example :
  * sudo ln -s /home/odr/config/supervisor/f3.conf /etc/supervisor/conf.d/f3.conf
  * sudo supervisorctl reread
  * sudo supervisorctl update

All services are launch from supervisor.

To show status of all services :
  * sudo supervisorctl status

To [stop|start|restart] a service :
  * sudo supervisorctl [stop|start|restart] service-name

To apply change after change anything in /home/odr/config/supervisor/ file you need to call supervisor to reread and update configuration.
  * sudo supervisorctl reread
  * sudo supervisorctl update

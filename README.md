ODR-mmbTools scripts for 24/7 operation
=======================================
version : radioHack2016


Prerequisites
-------------
You need to have a working ODR-DabMux, ODR-DabMod, FDK-AAC-DABplus and/or
Toolame-DAB configuration to use these scripts. Also
[supervisor](http://supervisord.org/) is needed. (apt-get install supervisor)

The tools are expected to be installed in their usual place in /usr/local.

Folder structure
----------------

The 'config' folder contains all needed configuration file and needed to be
moved into /home/odr/ folder.

  * config/mod.conf : contains ODR-DabMod configuration
  * config/mux.conf : contains ODR-DabMux configuration
  * config/supervisor/ : contains all supervisor configuration files
  * config/mot/ : contains all dls and slide files. You need to create fifo
    with mkfifo for each radio (e.g. mkfifo /home/odr/config/mot/f3.pad)


About encoder and mot-encoder
-----------------------------

The encoder (toolame-dab or dabplus-enc) writes ICY-Text into a text file. You
need to create this file at first for each radio :
  * touch /home/odr/config/mot/f3.txt

mot-encoder reads ICY-Text information from previous text file and writes into
the pad file. This pad file need to be a FIFO and you need to create it for
each radio :
  * mkfifo /home/odr/config/mot/f3.pad

If you use Slide Show, you can put your images into the directory under mot
folder corresponding to the radio (example: /home/odr/config/mot/f3/)


About supervisor
----------------

You need to create sym link into /etc/supervisor/conf.d/ for each radio
configuration file and call supervisorctl to reread and update configuration.
Please refer to the official [supervisor](http://supervisord.org/)
documentation for details.

Example :
  * sudo ln -s /home/odr/config/supervisor/f3.conf /etc/supervisor/conf.d/f3.conf
  * sudo supervisorctl reread
  * sudo supervisorctl update

All services are launched from supervisor.

To show status of all services :
  * sudo supervisorctl status

To [stop|start|restart] a service :
  * sudo supervisorctl [stop|start|restart] service-name

To apply change after change anything in /home/odr/config/supervisor/ file you
need to call supervisor to reread and update configuration.
  * sudo supervisorctl reread
  * sudo supervisorctl update

Supervisor redirects all logs from the tools to files in /var/log/supervisor/
You may need to ensure yourself that this directory exists. The logs will get
rotated according to the policy defined by your distribution. More details in
the [child logging](http://supervisord.org/logging.html#child-process-logs)
section of the documentation.

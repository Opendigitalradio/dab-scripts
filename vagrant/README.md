# Introduction
[Vagrant](https://www.vagrantup.com) provides easy to configure, reproducible, and portable work environments on top of virtual management software like [Virtualbox](https://www.virtualbox.org/).

With Vagrant and Virtualbox, you can run the ODR-mmbTools regardless of the operating system you are using, such as Windows, MacOS, *BSD or any non-Debian Linux.

# Setup
1. Install Virtualbox
1. Install the Virtualbox Extension pack
1. Install Vagrant
1. Clone this repository or copy the Vagrantfile on your host
1. Create and start the virtual environment. This can take quite some task since it will compile most of the mmbtools:
    ```
    cd directory_containing_Vagrantfile
    vagrant up
    ```
1. If you have a USB transceiver:
    - Connect the transceiver device to the physical host that runs VirtualBox
    - Open VirtualBox and add a USB filter on the **odr-mmbtools** virtual machine
    - Login to the **odr-mmbtools** virtual machine:
        ```
        vagrant ssh
        ```
    - Review the sections **[output]** and **[soapyoutput]** in the file $HOME/config/odr-dabmod.ini and make the necessary changes
    - Logout from the **odr-mmbtools** virtual machine:
        ```
        exit
        ```

1. Restart the **odr-mmbtools** virtual machine on the physical host:
    ```
    vagrant reload
    ```

# Operations
Here are the url to access the following web interfaces from the phyical host:
- Supervisor: http://localhost:8001
- Multiplex Manager: http://localhost:8002
- Encoder Manager: http://localhost:8003

You can monitor the output of the multiplexer with dablin on localhost:9201:
```
nc localhost 9201 | dablin_gtk -f edi -I -1
```
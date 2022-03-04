# Introduction
[Vagrant](https://www.vagrantup.com) provides easy to configure, reproducible, and portable work environments on top of virtual management software like [Virtualbox](https://www.virtualbox.org/).

With Vagrant and Virtualbox, you can run the ODR-mmbTools regardless of the operating system you are using, such as Windows, MacOS, *BSD or any non-Debian Linux.

# Setup
1. Install Virtualbox for your operating system
1. Install the Virtualbox Extension pack
1. Install Vagrant for your operating system
1. Clone this repository or copy the Vagrantfile on your host
1. Create and start the virtual environment:
    ```
    # Go to the directory that contains the Vagrantfile
    vagrant up
    ```
1. Access the virtual session to build the ODR-mmbTools suite:
    ```
    vagrant ssh
    ```
1. Follow the instructions of the **README.md** in the install folder to build the ODR-mmbTools suite
1. Exit the virtual session with the command **exit**
1. Connect the SoapySDR transceiver device to your physical host where VirtualBox is running
1. Open VirtualBox and add a USB filter that relates to your SoapySDR device to the **odr-mmb** session
1. Restart the **odr-mmbtools** VirtualBox session with Vagrant:
    ```
    vagrant reload
    ```

# Operations
Once the ODR-mmbTools are installed, you no longer need to access the virtual session, unless you need to make configuration changes.

Here are the url to access the following web interfaces:
- Supervisor: http://localhost:8001
- Multiplex Manager: http://localhost:8002
- Encoder Manager: http://localhost:8003

You can monitor the output of odr-DabMux with dablin on localhost:9201
# Introduction
[Vagrant](https://www.vagrantup.com) provides easy to configure, reproducible, and portable work environments on top of virtual management software like Virtualbox or libvirt

With Vagrant and Virtualbox, you can run the ODR-mmbTools regardless of the operating system you are using, such as Windows, MacOS, *BSD or any non-Debian Linux.

# Setup
1. Install one of the following virtualization engines
	- [Virtualbox](https://www.virtualbox.org/) + Virtualbox Extension pack
	- [libvirt](https://wiki.debian.org/Vagrant) (recommended if your host runs on linux)
1. Install Vagrant
1. Connect the USB transceiver to the host that will the virtual environment
1. Clone this repository or copy the **Vagrantfile** on your host
1. If you are using libvirt:
	- Change the `:vendor` and `:product` values in the **Vagrantfile**, based on the output from command `lsusb`
1. Create and start the virtual environment. This can take quite some time since it will compile most of the mmbtools:
	```
	cd directory_containing_Vagrantfile
	vagrant up
	```
1. If you are using Virtualbox:
    - Open VirtualBox and add a USB filter to the virtual machine
1. Login to the virtual machine:
	```
	vagrant ssh
	```
1. Review the sections `[output]` and `[soapyoutput]` in the file $HOME/config/odr-dabmod.ini and make the necessary changes
1. Logout from the virtual machine:
	```
	exit
	```
1. Restart the virtual machine:
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
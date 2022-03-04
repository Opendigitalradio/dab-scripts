# Table of contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Removal](#removal)

# Introduction
The goal of the mmbtools-get shell script is to install:
- the [odr-mmbtools](https://www.opendigitalradio.org/mmbtools) components developed by the [Open Digital Radio](https://www.opendigitalradio.org/) non-profit association on a clean debian environment
- Working configuration files that you can later customize as you see fit

# Installation
## Preliminary notes
We **highly recommend** that you install odr-mmbTools on a **new debian** environment, starting from the Bullseye release. Since some software components, like the audio encoders or the modulator, are CPU-intensive, we recommend you setup a lite debian environment (ie. without a GUI framework).

If you want to quickly setup a lite clean debian environment, we suggest you use [Vagrant](https://www.vagrantup.com) associated with a virtualization hypervisor, like [Virtualbox](https://www.virtualbox.org). A sample Vagrantfile is available in the Vagrant folder of this repository.

## Steps
1. Sign-in with your user profile
1. Update your system:
   ```
   sudo apt-get update
   sudo apt-get upgrade -y
   ```
1. Find your time zone:
   ```
   timedatectl list-timezones
   ```
1. Set your time zone:
   ```
   sudo timedatectl set-timezone your_timezone
   ```
1. Install the git command:
   ```
   sudo apt-get install -y git
   ```
1. Clone this repository:
   ```
   cd $HOME

   # Clone the stable version of dab-scripts
   git clone https://github.com/opendigitalradio/dab-scripts.git

   # Or clone the next version of dab-scripts
   git clone --branch next https://github.com/opendigitalradio/dab-scripts.git
   ```
1. Install the ODR-mmbTools suite and the sample configuration folder
   ```
   # Install the stable version of odr-mmbTools
   bash $HOME/dab-scripts/install/mmbtools-get --branch master install

   # Or install the next version of odr-mmbTools
   bash $HOME/dab-scripts/install/mmbtools-get --branch next install
   ```

# Removal
If you wish to remove the odr-mmbTools suite and the sample configuration folder, then follow these steps:
1. Stop all odr-mmbTools related jobs in supervisor
2. Remove the ODR-mmbTools software suite and the configuration folder
   ```
   bash $HOME/dab-scripts/install/mmbtools-get remove
   ```

# Table of contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Test](#test)
- [Removal](#removal)

# Introduction
The goal of the mmbtools-get shell script is to install:
- the [odr-mmbtools](https://www.opendigitalradio.org/mmbtools) components developed by the [Open Digital Radio](https://www.opendigitalradio.org/) non-profit association on a clean debian environment
- Working configuration files that you can later customize as you see fit

# Installation
## Preliminary notes
We **highly recommend** that you install odr-mmbTools on a **new debian** environment, starting from the Bullseye release. Since some software components, like the audio encoders or the modulator, are CPU-intensive, we recommend you setup a lite debian environment (ie. without a GUI framework).

If you want to quickly play with the tools before installing anything on your host, we suggest you use our [docker-mmbtools](https://github.com/opendigitalradio/docker-mmbtools) repository.

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
   git clone https://github.com/opendigitalradio/dab-scripts.git
   ```
1. Install the ODR-mmbTools suite and the sample configuration folder
   ```
   # Install the stable version of odr-mmbTools
   sudo bash dab-scripts/install/mmbtools-get --branch master install

   # Or install the development version of odr-mmbTools
   sudo bash dab-scripts/install/mmbtools-get --branch next install
   ```

### Notes
1. You must use the argument `--odr-user` with the command **mmbtools-get** in the following 2 cases:
	- You are not running **mmbtools-get** with `sudo`: you must thus specify the odr user profile
	- You are running **mmbtools-get** with `sudo` and you do not want your current user to be the odr user profile
1. **mmbtools-get** will create the user specified with `odr-user` if it does not exist:
	- password: odr
	- additional groups: audio,dialout

# Test
Once the installation is completed, you can test the provided encoders and multiplex configuration files by applying the following steps:
1. Install dablin
   ```
   sudo apt-get install -y dablin
   ```
1. Access the supervison web user interface `http://<YOUR_HOST>:8001`, where <YOUR_HOST> is the host where you installed the dab script. The user is `odr` and the password is `odr`
1. Start the 4 encoders and `20-Multiplex`
1. Monitor the multiplex stream
   ```
   nc <YOUR_HOST> 9201 | dablin_gtk -f edi -I -1
   ```

# Removal
If you wish to remove the odr-mmbTools suite and the sample configuration folder, then follow these steps:
1. Stop all odr-mmbTools related jobs in supervisor
2. Remove the ODR-mmbTools software suite and the configuration folder
   ```
   sudo bash dab-scripts/install/mmbtools-get remove
   ```

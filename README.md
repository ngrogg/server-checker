# Server Checker

## Overview
A BASH script to check and log the overall status of a Linux server's processes, services, users and disks.
Designed primarily for DEB and RPM based systems. Should be easy enough to expand to other package managers. <br>

## Usage
Just run the script: `./serverChecker.sh`. <br> <br>
Creates it's own log file <br>

## Requirements
### Sudoer/Wheel group
Script doesn't need run as root user, however the user running script will need sudo access. <br>
Doas is planned in the future.

### Packages
The following packages are required: <br>
* **iproute2**
* **lsof**

The script will attempt to install them if they're not found.

#!/usr/bin/bash

# Server Checker
# BASH script to view/log server information
# By Nicholas Grogg


# Template log messages, remove when complete
#echo "$(date +%Y%m%d) - " | tee -a log/serverChecker.$(date +%Y%m%d).log
#echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log
# | tee -a log/serverChecker.$(date +%Y%m%d).log

# Preparation
## Logic checks/Validation
echo "$(date +%Y%m%d) - Beginning Validation Checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

### Privilege Escalation check
if [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo found" | tee -a log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

elif [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - doas found" | tee -a log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="doas"

elif [[ -f /usr/bin/sudo && -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo and doas found, default to sudo" | tee -a log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

else
    echo "$(date +%Y%m%d) - Neither sudo nor doas found, exiting" | tee -a log/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

echo "$(date +%Y%m%d) - Ending Validation checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

## Create log file and folder if it doesn't exist
if [[ ! -d log ]]; then
        mkdir log
        echo "$(date +%Y%m%d) - Begin Server Checker run" | tee -a log/serverChecker.$(date +%Y%m%d).log
        echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log
fi

## Package checks
echo "$(date +%Y%m%d) - Beginning Server Checker package checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

### lsof check
if [[ -f /usr/bin/lsof ]]; then
    echo "$(date +%Y%m%d) - Required package lsof found, proceeding" | tee -a log/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package lsof not found, attempting install" | tee -a log/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install lsof -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install lsof -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a log/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

# ss check, ss is part of iproute2
if [[ -f /usr/bin/ss ]]; then
    echo "$(date +%Y%m%d) - Required package ss found, proceeding" | tee -a log/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package ss not found, attempting install" | tee -a log/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install iproute2 -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install iproute2 -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a log/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

# sysstat check, mpstat is part of sysstat
if [[ -f /usr/bin/mpstat ]]; then
    echo "$(date +%Y%m%d) - Required package mpstat found, proceeding" | tee -a log/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package sysstat not found, attempting install" | tee -a log/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install sysstat -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install sysstat -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a log/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

echo "$(date +%Y%m%d) - Ending Server Checker package checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Basic checks
echo "$(date +%Y%m%d) - Beginning basic checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log
## Uptime
echo "$(date +%Y%m%d) - Uptime" | tee -a log/serverChecker.$(date +%Y%m%d).log
uptime | tee -a log/serverChecker.$(date +%Y%m%d).log

## CPU Load
echo "$(date +%Y%m%d) - CPU usage" | tee -a log/serverChecker.$(date +%Y%m%d).log
mpstat | tee -a log/serverChecker.$(date +%Y%m%d).log

## RAM usage
echo "$(date +%Y%m%d) - RAM usage" | tee -a log/serverChecker.$(date +%Y%m%d).log
free -g | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending basic checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Services
echo "$(date +%Y%m%d) - Beginning Service checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

## Check for failed services
echo "$(date +%Y%m%d) - Failed services" | tee -a log/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=failed | tee -a log/serverChecker.$(date +%Y%m%d).log

## Check for dead services, skip not-found services
echo "$(date +%Y%m%d) - Dead services" | tee -a log/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=dead | grep -v not-found | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Service checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Networking
echo "$(date +%Y%m%d) - Beginning Networking checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

## Check what ports are in use and by what
#echo "$(date +%Y%m%d) - Port usage" | tee -a log/serverChecker.$(date +%Y%m%d).log
### Command break down from man ss
### -p, Show process using socket
### -l, Show listening only
### -u, Display UDP sockets
### -n, Do not try to resolve service names
### -t, Display TCP sockets
ss -plunt | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Networking checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Users
echo "$(date +%Y%m%d) - Beginning User checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log
## Last 10 logins
echo "$(date +%Y%m%d) - Last logins" | tee -a log/serverChecker.$(date +%Y%m%d).log
last | head -n 10 | tee -a log/serverChecker.$(date +%Y%m%d).log

#TODO
## Check for expired passwords
echo "$(date +%Y%m%d) - Expired Passwords" | tee -a log/serverChecker.$(date +%Y%m%d).log

## Check sudoer file integrity (sudo and doas)
echo "$(date +%Y%m%d) - Escalation Check" | tee -a log/serverChecker.$(date +%Y%m%d).log
if [[ "$escalationProgram" == "sudo" ]]; then
    sudo -l | tee -a log/serverChecker.$(date +%Y%m%d).log
fi

if [[ "$escalationProgram" == "doas" ]]; then
    doas doas -C /etc/doas.conf && echo "All good" || echo "There is an error"  | tee -a log/serverChecker.$(date +%Y%m%d).log
fi

echo "$(date +%Y%m%d) - Ending User checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Disk information
echo "$(date +%Y%m%d) - Beginning Disk checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

## Find large logs (> 1GB)
echo "$(date +%Y%m%d) - Log files larger than 1 GB" | tee -a log/serverChecker.$(date +%Y%m%d).log

#TODO
## Files held in memory
echo "$(date +%Y%m%d) - Files held in memory" | tee -a log/serverChecker.$(date +%Y%m%d).log

#TODO
## Low disk space
echo "$(date +%Y%m%d) - Disk Space check" | tee -a log/serverChecker.$(date +%Y%m%d).log

#TODO
## Low disk inodes
echo "$(date +%Y%m%d) - Disk Inode check" | tee -a log/serverChecker.$(date +%Y%m%d).log

#TODO
## Check for "Structure needs cleaning" message in logs
echo "$(date +%Y%m%d) - Disk Structure check" | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Disk checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Updates
## Check for updates
echo "$(date +%Y%m%d) - Beginning Update checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Available updates" | tee -a log/serverChecker.$(date +%Y%m%d).log
# Expand to other package managers as needed
if [[ -f /usr/bin/apt ]]; then
    echo "$(date +%Y%m%d) - APT package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
    apt list --upgradable
elif [[ -f /usr/bin/dnf ]]; then
    echo "$(date +%Y%m%d) - DNF package manager found" | tee -a log/serverChecker.$(date +%Y%m%d).log
    dnf check-update
else
    echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a log/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

echo "$(date +%Y%m%d) - Ending Update checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Closing statement
echo "$(date +%Y%m%d) - End Server Checker run" | tee -a log/serverChecker.$(date +%Y%m%d).log

#!/usr/bin/bash

# Server Checker
# BASH script to view/log server information
# By Nicholas Grogg


# Template log messages, remove when complete
#echo "$(date +%Y%m%d) - " | tee -a log/serverChecker.$(date +%Y%m%d).log
#echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log
#| tee -a log/serverChecker.$(date +%Y%m%d).log

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
echo "$(date +%Y%m%d) - " | tee -a log/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=failed | tee -a log/serverChecker.$(date +%Y%m%d).log

## Check for dead services, skip not-found services
echo "$(date +%Y%m%d) - " | tee -a log/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=dead | grep -v not-found | tee -a log/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Service checks" | tee -a log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a log/serverChecker.$(date +%Y%m%d).log

# Networking
## Check what ports are in use and by what

# Users
## Last 10 logins
## Check for expired passwords
## Check sudoer file integrity (sudo and doas)

# Disk information
## Find large logs (> 1GB)
## Large files held in memory
## Low disk space
## Low disk inodes
## Check for "Structure needs cleaning" message in logs

# Updates
## Check for updates

# Closing statement
echo "$(date +%Y%m%d) - End Server Checker run" | tee -a log/serverChecker.$(date +%Y%m%d).log

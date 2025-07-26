#!/usr/bin/bash

# Server Checker
# BASH script to view/log server information
# By Nicholas Grogg


# Template log messages, remove when complete
#echo "$(date +%Y%m%d) - " >> log/serverChecker.$(date +%Y%m%d).log
#echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log

# Preparation
## Create log file and folder if it doesn't exist
if [[ ! -d log ]]; then
        mkdir log
        echo "$(date +%Y%m%d) - Begin Server Checker run" >> log/serverChecker.$(date +%Y%m%d).log
        echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log
fi

## Package checks
echo "$(date +%Y%m%d) - Beginning Server Checker package checks" >> log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log

### lsof check
if [[ -f /usr/bin/lsof ]]; then
    echo "$(date +%Y%m%d) - Required package lsof found, proceeding" >> log/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package lsof not found, attempting install" >> log/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" >> log/serverChecker.$(date +%Y%m%d).log
        sudo apt install lsof -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" >> log/serverChecker.$(date +%Y%m%d).log
        sudo dnf install lsof -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" >> log/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

# ss check
if [[ -f /usr/bin/ss ]]; then
    echo "$(date +%Y%m%d) - Required package ss found, proceeding" >> log/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package ss not found, attempting install" >> log/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" >> log/serverChecker.$(date +%Y%m%d).log
        sudo apt install iproute2 -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" >> log/serverChecker.$(date +%Y%m%d).log
        sudo dnf install iproute2 -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" >> log/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

echo "$(date +%Y%m%d) - Ending Server Checker package checks" >> log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log

## Logic checks/Validation
echo "$(date +%Y%m%d) - Beginning Validation Checks" >> log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log

### Privilege Escalation check
if [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo found" >> log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

elif [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - doas found" >> log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="doas"

elif [[ -f /usr/bin/sudo && -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo and doas found, default to sudo" >> log/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

else
    echo "$(date +%Y%m%d) - Neither sudo nor doas found, exiting" >> log/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

echo "$(date +%Y%m%d) - Ending Validation checks" >> log/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" >> log/serverChecker.$(date +%Y%m%d).log

# Basic checks
## Uptime
## CPU Load
## RAM usage

# Services
## Check for failed services
## Check for dead services, skip not-found services

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
echo "$(date +%Y%m%d) - End Server Checker run" >> log/serverChecker.$(date +%Y%m%d).log

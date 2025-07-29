#!/usr/bin/bash

# Server Checker
# BASH script to view/log server information
# By Nicholas Grogg

# Preparation
## Variable for log directory, change as needed
logDir="log"

## Variable for disk space checks, expand to additional variables for other filepaths/partitions as needed
### Command break down
### df -h, list available disk space -h for human readable
### grep "/$", find line that ends with just a slash. Should be root partition.
### awk '{print $5}', Print the fifth option. Disk space w/ percentage.
### sed 's/.$//', Remove last character. Leave just the number.
spaceInUse=$(df -h | grep "/$" | awk '{print $5}' | sed 's/.$//')

### df -hi, list available disk inodes -h for human readable, -i for inodes
inodesInUse=$(df -hi | grep "/$" | awk '{print $5}' | sed 's/.$//')

## Create log file and folder if it doesn't exist
if [[ ! -d log ]]; then
    mkdir log
    echo "$(date +%Y%m%d) - Begin Server Checker run" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Begin Server Checker run" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

## Logic checks/Validation
echo "$(date +%Y%m%d) - Beginning Validation Checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

### Privilege Escalation check
if [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

elif [[ -f /usr/bin/sudo && ! -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - doas found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    escalationProgram="doas"

elif [[ -f /usr/bin/sudo && -f /usr/bin/doas ]]; then
    echo "$(date +%Y%m%d) - sudo and doas found, default to sudo" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    escalationProgram="sudo"

else
    echo "$(date +%Y%m%d) - Neither sudo nor doas found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

echo "$(date +%Y%m%d) - Ending Validation checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Package checks
echo "$(date +%Y%m%d) - Beginning Server Checker package checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

### lsof check
if [[ -f /usr/bin/lsof ]]; then
    echo "$(date +%Y%m%d) - Required package lsof found, proceeding" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package lsof not found, attempting install" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install lsof -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install lsof -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

# ss check, ss is part of iproute2
if [[ -f /usr/bin/ss ]]; then
    echo "$(date +%Y%m%d) - Required package ss found, proceeding" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package ss not found, attempting install" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install iproute2 -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install iproute2 -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

# sysstat check, mpstat is part of sysstat
if [[ -f /usr/bin/mpstat ]]; then
    echo "$(date +%Y%m%d) - Required package mpstat found, proceeding" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Required package sysstat not found, attempting install" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    #### Check for apt/dnf, exit w/ 1 otherwise expand with other package managers as desired
    if [[ -f /usr/bin/apt ]]; then
        echo "$(date +%Y%m%d) - APT package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram apt install sysstat -y
    elif [[ -f /usr/bin/dnf ]]; then
        echo "$(date +%Y%m%d) - DNF package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        $escalationProgram dnf install sysstat -y
    else
        echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
        exit 1
    fi
fi

echo "$(date +%Y%m%d) - Ending Server Checker package checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Basic checks
echo "$(date +%Y%m%d) - Beginning basic checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
## Uptime
echo "$(date +%Y%m%d) - Uptime" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
uptime | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## CPU Load
echo "$(date +%Y%m%d) - CPU usage" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
mpstat | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## RAM usage
echo "$(date +%Y%m%d) - RAM usage" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
free -g | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending basic checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Services
echo "$(date +%Y%m%d) - Beginning Service checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Check for failed services
echo "$(date +%Y%m%d) - Failed services" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=failed | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Check for dead services, skip not-found services
echo "$(date +%Y%m%d) - Dead services" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
sudo systemctl list-units --type=service --state=dead | grep -v not-found | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Service checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Networking
echo "$(date +%Y%m%d) - Beginning Networking checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Check what ports are in use and by what
#echo "$(date +%Y%m%d) - Port usage" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
### Command break down from man ss
### -p, Show process using socket
### -l, Show listening only
### -u, Display UDP sockets
### -n, Do not try to resolve service names
### -t, Display TCP sockets
ss -plunt | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Ending Networking checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Users
echo "$(date +%Y%m%d) - Beginning User checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
## Last 10 logins
echo "$(date +%Y%m%d) - Last logins" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
last | head -n 10 | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Check for user password expirations
echo "$(date +%Y%m%d) - User password check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
for user in $(ls /home); do echo $user; $escalationProgram chage -l $user | grep "Password expires"; done |  tee -a $logDir/serverChecker.$(date +%Y%m%d).log

### Expand to other directories as needed. For example, SFTP users jailed to a specific directory

## Check sudoer file integrity (sudo and doas)
echo "$(date +%Y%m%d) - Escalation Check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
if [[ "$escalationProgram" == "sudo" ]]; then
    sudo -l | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

if [[ "$escalationProgram" == "doas" ]]; then
    doas doas -C /etc/doas.conf && echo "All good" || echo "There is an error"  | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

echo "$(date +%Y%m%d) - Ending User checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Disk information
echo "$(date +%Y%m%d) - Beginning Disk checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Find large logs (> 1GB)
echo "$(date +%Y%m%d) - Log files larger than 1 GB" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

### Find files in /var/log over 1 GB in size
$escalationProgram find /var/log -type f -size +1G | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

## Files held in memory
echo "$(date +%Y%m%d) - Deleted files held in memory" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
### Command breakdown
### lsof +L1, show files with a link count less than 1. Typical in deleted files held in memory
### tail -n +2, remove lsof headers. Required for number formatting
### numfmt --field=7 --to=iec, Format field 7 (the size field) to single letter suffix (M, G etc)
### sort -k7 -n -r, sort key 7 (the size field) numerically and in reverse
$escalationProgram lsof +L1 | tail -n +2 | numfmt --field=7 --to=iec | sort -k7 -n -r

## Low disk space, use 10% free space as threshold
echo "$(date +%Y%m%d) - Disk Space check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
if [[ $spaceInUse -gt 90 ]]; then
    echo "$(date +%Y%m%d) - Less than 10% Disk Space available, checking file usage" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

    ### Command breakdown
    ### du --max-depth=5 -chax / 2>&1, disk usage check / five levels deep 
    ### -c total -h human readable -a all files -x use only current file system
    ### 2>&1, STDERR to STDOUT
    ### grep '[0-9\.]\+G', grep for GB
    ### sort -hr, sort human readable and reverse
    ### head, list first few entries
    du --max-depth=5 -chax / 2>&1 | grep '[0-9\.]\+G' | sort -hr | head | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

else
    echo "$(date +%Y%m%d) - More than 10% Disk Space available" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

## Check for SWAP
echo "$(date +%Y%m%d) - SWAP check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

if [[ $(grep -i swap /etc/fstab) ]]; then
    echo "$(date +%Y%m%d) - SWAP found in fstab" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - SWAP not found in fstab" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

## Low disk inodes, use 10% free inodes as threshold
echo "$(date +%Y%m%d) - Disk Inode check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
if [[ $inodesInUse -gt 90 ]]; then
    echo "$(date +%Y%m%d) - Less than 10% Disk Inodes available, checking node usage" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

    ### Command breakdown
    ### find / -xdev -printf '%h\n', find files in / and stay on current file system print directory and each item is on a new line
    ### sort, sort returned filepaths
    ### uniq -c, count unique occurrences of item
    ### sort -k 1 -n, sort on field 1 by number
    ### tail -20, list last 20 files
    $escalationProgram find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n | tail -20 | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

else
    echo "$(date +%Y%m%d) - More than 10% Disk Inodes available" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

## Check for "Structure needs cleaning" message in logs
echo "$(date +%Y%m%d) - Disk Structure check" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
if [[ -f /usr/bin/apt ]]; then
    check=$($escalationProgram grep -i 'structure needs cleaning' /var/log/syslog | wc -l)
elif [[ -f /usr/bin/dnf ]]; then
    check=$($escalationProgram grep -i 'structure needs cleaning' /var/log/messages | wc -l)
else
    echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

if [[ $check -gt 0 ]]; then
    echo "$(date +%Y%m%d) - $check instances of 'structure needs cleaning' message found! Disk should be reviewed for corruption!" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
else
    echo "$(date +%Y%m%d) - Disk Structure clear" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
fi

echo "$(date +%Y%m%d) - Ending Disk checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Updates
## Check for updates
echo "$(date +%Y%m%d) - Beginning Update checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

echo "$(date +%Y%m%d) - Available updates" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
# Expand to other package managers as needed
if [[ -f /usr/bin/apt ]]; then
    echo "$(date +%Y%m%d) - APT package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    apt list --upgradable
elif [[ -f /usr/bin/dnf ]]; then
    echo "$(date +%Y%m%d) - DNF package manager found" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    dnf check-update
else
    echo "$(date +%Y%m%d) - Neither APT nor DNF found, exiting" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
    exit 1
fi

echo "$(date +%Y%m%d) - Ending Update checks" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

# Closing statement
echo "$(date +%Y%m%d) - End Server Checker run" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log
echo "----------------------------------------------------" | tee -a $logDir/serverChecker.$(date +%Y%m%d).log

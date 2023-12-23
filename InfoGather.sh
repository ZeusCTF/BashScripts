#!/bin/bash

#basic system enumeration:
echo "KERNEL/SYSTEM INFO"
echo ""
uname -a
echo ""
echo "Sudo version:"
sudo -V | grep "Sudo ver"
echo ""
echo "Disk information:" #Native command for MACs, could work on Linux
diskutil list
echo "----------"
echo "NETWORK INFO"
echo ""
ip -4 addr
# Check the exit status of the command
if [ $? -ne 0 ]; then
    echo "Error: The command failed, are you on a Mac?"
    #by default, ip does not appear to be installed on Mac systems, script will try to run ifconifg if ip fails
    ifconfig
fi
echo ""
echo "ARP Information:"
arp -a
echo ""
scutil --dns
# Check the exit status of the command
if [ $? -ne 0 ]; then
    echo "Error: The command failed, you are probably on linux"
    #MacOS does not use /etc/resolv.conf, first checking if the above command works
    #Then if it doesnt, then we can look for the hostname 
    cat /etc/resolv.conf | grep hostname
fi
echo "----------"
echo ""
#basic user enum
echo "USER INFO"
echo "----------------"
id_output=$(id)

for line in $id_output; do
    echo "$line"
done
echo ""
echo "Login information:"
last
echo ""
echo ""

env_output=$(env)

for line in $env_output; do
    echo $line
done


echo ""
echo ""



echo "Do you have access to write to a PATH folder?"
IFS=:

for directory in $PATH; do
    # Check if the directory is writable
    if [ -w "$directory" ]; then
        echo "Possible escalation path: $directory"
    else
        echo "No permissions: $directory"
    fi
done

echo ""
echo ""

echo "Logged in users:"
who

echo ""
echo ""

echo "Existing user accounts:"
#note, for MACs this output is not super useful as during testing, custom accounts don't show.  But something like "ls /Users/ would show a list of accounts if they have a home dir"
awk -F: '{ print $1}' /etc/passwd

echo ""

home_dir=$(ls /Users/)

for directory in $home_dir; do
    echo "$directory"
done
echo ""
echo ""
echo "Current running processes:"
echo ""
ps aux



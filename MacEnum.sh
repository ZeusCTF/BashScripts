#!/bin/bash

#basic system enumeration:
echo "KERNEL/SYSTEM INFO"
echo ""
uname -a
echo ""
echo "Apple kernel extensions"
ls /System/Library/Extensions
echo ""
echo "Custom kernel extensions"
ls /Library/Extensions
echo ""
echo "Sudo version:"
sudo -V | grep "Sudo ver"
echo ""
echo "Disk information:" #Native command for MACs
diskutil list
echo ""
echo "Is MacOS GateKeeper enabled?"
spctl --status
echo ""
echo "Installed Applications"
ls /Applications
echo ""
echo "System Applications"
ls /System/Applications
echo ""
system_profiler SPApplicationsDataType
echo ""
echo "More system info"
system_profiler SPSoftwareDataType
echo ""
echo "----------"
echo "NETWORK INFO"
echo ""
ip -4 addr
# Check the exit status of the command
if [ $? -ne 0 ]; then
    echo "Error: The command failed, trying ifconfig"
    #by default, ip does not appear to be installed on Mac systems, script will try to run ifconifg if ip fails
    ifconfig
fi
echo ""
echo "ARP Information:"
arp -a
echo ""
scutil --dns
echo "----------"
echo ""

#basic user enum
echo "USER INFO"
echo "----------------"
id_output=$(id)

for line in $id_output; do
    echo "$line"
done
echo "Trying to read messages:"
sqlite3 $HOME/Library/Messages/chat.db 'select * from message'
echo ""
echo "Files that reference a 'password'"
mdfind password
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





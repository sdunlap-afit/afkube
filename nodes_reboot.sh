#!/bin/bash

# Get password from pw.txt
PW=$(<pw.txt)

# Read in list of IP addresses from ips.txt and ssh reboot them (passing "pw" as password for sudo)
while IFS= read -r IP; do
    echo "Rebooting $IP"
    echo $PW | ssh pi@$IP "sudo -S reboot 2> /dev/null"
done < ips.txt

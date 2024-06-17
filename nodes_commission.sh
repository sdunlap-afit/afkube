#!/bin/bash

# Get password from pw.txt
PW=$(<pw.txt)

# Read in list of IP addresses from ips.txt and ssh reboot them (passing "pw" as password for sudo)
while IFS= read -r IP; do
    echo "Commissioning $IP"

    # Add IP to known hosts
    ssh-keyscan -H $IP >> ~/.ssh/known_hosts

    # Add SSH key to node
    sshpass -p $PW ssh-copy-id -i ~/.ssh/id_ed25519.pub pi@$IP

    scp scripts/node_setup.sh pi@$IP:~/ 
    # ssh -t pi@$IP "sudo ~/node_setup.sh && rm ~/node_setup.sh"
    echo $PW | ssh pi@$IP "sudo -S ~/node_setup.sh && rm ~/node_setup.sh"

    echo
    
done < ips.txt

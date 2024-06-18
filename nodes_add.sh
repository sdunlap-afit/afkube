#!/bin/bash

# IP address of target node as arg0
NODE_IP=$1

# Check to make sure NODE_IP is valid
if [[ ! $NODE_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address"
    exit 1
fi

# Use ping to check NODE_IP
if ! ping -c 1 $NODE_IP &> /dev/null; then
    echo "Node is unreachable"
    exit 1
fi


# Check if node is already added to microk8s
if microk8s kubectl get nodes -o wide | grep -q $NODE_IP; then
    echo "Node is already part of the cluster"
    exit 1
fi


# Prompt the user to make sure they want to do this
read -p "Are you sure you want to add $NODE_IP to the cluster? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting"
    exit 1
fi

PW=$(<pw.txt)

# Get second line from the add-node command
JOIN_CMD=$(microk8s add-node | sed -n '2p')

# Find and replace IP address with 10.10.10.1
JOIN_CMD=$(echo $JOIN_CMD | sed "s/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/10.10.10.1/")

echo "Join command: $JOIN_CMD"

# Run the join command on the target node
ssh pi@$NODE_IP "sudo -S $JOIN_CMD"


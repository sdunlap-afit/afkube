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

# Prompt the user to make sure they want to do this
read -p "Are you sure you want to add $NODE_IP to the cluster? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting"
    exit 1
fi


TEST="From the node you wish to join to this cluster, run the following:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05

Use the '--worker' flag to join a node as a worker not running the control plane, eg:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05 --worker

If the node you are adding is not reachable through the default interface you can use one of the following:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05
microk8s join 10.23.209.1:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05
microk8s join 172.17.0.1:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05"

# JOIN_CMD=$(microk8s add-node | sed -n '2p')

# Get second line from the add-node command
JOIN_CMD=$(echo "$TEST" | sed -n '2p')

echo "Join command: $JOIN_CMD"

# Run the join command on the target node
# ssh pi@$NODE_IP "$JOIN_CMD"


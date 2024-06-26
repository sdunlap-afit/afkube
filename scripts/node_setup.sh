#!/bin/bash

# Script expects to be run with sudo

# Run remotely with: 
# IP=192.168.237.103; scp node_setup.sh $USER@$IP:~/ && ssh -t $USER@$IP "sudo ~/node_setup.sh && rm ~/node_setup.sh"

# Static range - .2 - .99

SRV_IP=192.168.237.101
USER=user

apt update 
apt upgrade -y 
       
# Taken care of by Ubuntu Server Install process
# snap install microk8s --classic

##### Enable necessary features #####

# This is a Pi thing
# sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt


##### Add user to microk8s group #####

usermod -a -G microk8s $USER
mkdir -p /home/$USER/.kube
chown -f -R $USER /home/$USER/.kube


##### Add insecure registry to docker #####

echo "{
    \"log-level\":        \"error\",
    \"insecure-registries\":[\"192.168.237.101:32000\"]
}" > /var/snap/docker/current/config/daemon.json


##### Add insecure registry to microk8s #####

mkdir -p /var/snap/microk8s/current/args/certs.d/$SRV_IP:32000
touch /var/snap/microk8s/current/args/certs.d/$SRV_IP:32000/hosts.toml

echo "server = \"http://$SRV_IP:32000\"

[host.\"http://$SRV_IP:32000\"]
capabilities = [\"pull\", \"resolve\"]" > /var/snap/microk8s/current/args/certs.d/$SRV_IP:32000/hosts.toml

# reboot


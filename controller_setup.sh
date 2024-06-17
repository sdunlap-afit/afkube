#!/bin/bash

##### Every Node #####

sudo apt update && sudo apt upgrade -y

sudo snap install microk8s --classic

# Enable necessary features

sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt

# Add user to microk8s group

sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
sudo chown -f -R $USER ~/.kube



##### Controller Only #####

echo "Run this on the controller node after setup.sh"

microk8s enable registry

# sudo reboot
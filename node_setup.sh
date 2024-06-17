#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo snap install microk8s --classic

##### Enable necessary features #####

sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt


##### Add user to microk8s group #####

sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
sudo chown -f -R $USER ~/.kube


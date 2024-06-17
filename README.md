# microk8s_pi
Simple setup for microk8s



# Main Controller setup

Local LAN IP is expected to be 10.10.10.1

DHCP server running on eth0 with ip range 10.10.10.10+

NAT is enabled


```bash
sudo apt install -y sshpass

sudo .scripts/node_setup.sh
sudo reboot

microk8s enable registry
```
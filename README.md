# microk8s_pi
Simple setup for microk8s



# Main Controller setup

```bash
sudo apt install -y sshpass

sudo .scripts/node_setup.sh
sudo reboot

microk8s enable registry
```
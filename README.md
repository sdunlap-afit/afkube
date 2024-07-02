



# k3s

Favorite so far. Not quite as easy as microk8s, but it doesn't seem to include any bloat.

On master node:

```bash
curl -sfL https://get.k3s.io | sh -
```

To add worker nodes, on the master node, run:

```bash
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
SRV_IP=$(hostname -I | awk '{print $1}')

# Add the worker node using SSH
WKR_IP=10.1.10.121
ssh -t $WKR_IP "curl -sfL https://get.k3s.io | K3S_URL=https://$SRV_IP:6443 K3S_TOKEN=$TOKEN sh -"

# OR copy the output of this and run it on the worker node
echo "curl -sfL https://get.k3s.io | K3S_URL=https://$SRV_IP:6443 K3S_TOKEN=$TOKEN sh -"

# Example output:
# curl -sfL https://get.k3s.io | K3S_URL=https://10.1.10.115:6443 K3S_TOKEN=K106f6d45b47e48fb8da5b1fa3779ad3bebf8ca3e428440c07890f2fb02b00da3f7::server:aceb90efba4ba28f2836a313f0e86a54 sh -
```

This will get you a barebones cluster.

# Set the roles of the worker nodes

```bash
sudo kubectl label node <node-name> node-role.kubernetes.io/worker=worker
```



# Portainer

```bash
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm upgrade --install --create-namespace -n portainer portainer portainer/portainer --set tls.force=true
```
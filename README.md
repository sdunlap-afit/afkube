
This is just a dumping ground for my notes on setting up a kubernetes cluster. I'm using Ubuntu Server 24.04 LTS for all nodes.



# k3s

Favorite so far. Not quite as easy as microk8s, but it doesn't seem to include as much bloat. It's basically a barebones k8s cluster with a relatively easy setup. 


## Issues

If you use VMs for k3s, they can be too slow for some standard deployments. If you get errors related to readiness probes or liveliness probes, you may need to increase the timeouts for those specific services.

Example:

```bash
kubectl edit deployment/gitlab-gitlab-runner -n gitlab
```



# Install k3s on the master node

```bash
# The built-in load balancer is not ideal. Disable it during install and we'll instal metallb later.
curl -sfL https://get.k3s.io | sh - --disable servicelb
```

Install metallb

```bash
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb --namespace metallb-system --create-namespace
```

Then create a yaml file with the following content and apply it.

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.1.10.10-10.1.10.50
```




User permissions for kubectl

```bash
echo "alias kubectl='k3s kubectl'" >> ~/.bashrc

mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
sudo chown -f -R $USER ~/.kube
echo "export KUBECONFIG=~/.kube/k3s.yaml" >> ~/.bashrc
source ~/.bashrc # or logout and back in or run `bash`
```

# Add worker nodes

First, get the join command from the master node.

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


# Set the roles of the worker nodes

By default, nodes are added without a role.

```bash
kubectl label node <node-name> node-role.kubernetes.io/worker=worker
```


# Helm setup

We also need to install helm. There are other methods, but this is the easier of the two official methods.

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh && rm get_helm.sh
```


# Portainer

```bash
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm upgrade --install --create-namespace -n portainer portainer portainer/portainer --set tls.force=true
```

Helm will output these commands to get the Portainer URL:

```bash
export NODE_PORT=$(kubectl get --namespace portainer -o jsonpath="{.spec.ports[0].nodePort}" services portainer)
export NODE_IP=$(kubectl get nodes --namespace portainer -o jsonpath="{.items[0].status.addresses[0].address}")
echo https://$NODE_IP:$NODE_PORT
```


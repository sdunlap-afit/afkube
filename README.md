# microk8s_pi
Simple setup for microk8s



# Main Controller setup

Local LAN IP is expected to be 10.10.10.1

DHCP server running on eth0 with ip range 10.10.10.10+

NAT is enabled


```bash
sudo apt install -y sshpass docker.io

sudo usermod -aG docker $USER


sudo .scripts/node_setup.sh
sudo reboot

microk8s enable registry
```

## DHCP/DNS

```bash
sudo apt install dnsmasq
```


`/etc/dnsmasq.conf`

```
interface = eth0
no-dhcp-interface = wlan0

# IPv4 address range and lease time
dhcp-range = 10.10.10.10,10.10.10.240,24h

domain-needed
bogus-priv
no-resolv
cache-size=1000

server=10.1.2.10
server=10.1.2.2
```

```bash
sudo /etc/init.d/dnsmasq restart
```



# Dockering

The cluster is built with Raspberry Pi, so we need to build images for ARM64.

These instructions assume you're building on the controller, but you should probably do it somewhere else and replace `10.10.10.1` with the controllers hostname or IP.


```bash
docker buildx build --platform linux/arm64 -t your-image-name:tag .

docker tag your-image-name:tag 10.10.10.1:32000/your-image-name:arm64
docker push 10.10.10.1:32000/your-image-name:arm64

docker buildx build --platform linux/arm64 -t py42:arm64 .devcontainer/
docker push 10.10.10.1:32000/py42:arm64
```


```bash
microk8s kubectl delete pods py42
microk8s kubectl get pods
microk8s kubectl get events
microk8s kubectl get pods
microk8s kubectl apply -f test.yaml
microk8s kubectl run --image=10.10.10.1:32000/py42:arm64 py42 -- /usr/bin/echo HELLO WORLD
```


# Samba Share

Set up a smb shared drive on another pi (`pinas`)

```bash
tar -czf testsc.tar.gz testsc/

tar -xzf testsc.tar.gz
```


```bash
smbclient //pinas/shared -U pi% -c "ls"

smbclient //pinas/shared -U pi% -c 'put testsc.tar.gz'
smbclient //pinas/shared -U pi% -c 'get test.txt'

```
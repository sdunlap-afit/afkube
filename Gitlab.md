

# Instructions fro standing up Gitlab on a Kubernetes cluster

## Prerequisites

1. A Kubernetes cluster
1. Helm
1. kubectl
1. A domain name
1. An SSL certificate for the domain name (from Ryan)

## Steps




1. Obtain cert from Ryan

```bash
kubectl create secret tls gitlab-cert --cert=<path/to-full-chain.crt> --key=<path/to.key>
```

or generate a self-signed cert

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout tls.key -out tls.crt -subj "/CN=10.1.10.33.nip.io"
kubectl create secret tls gitlab-cert --cert=tls.crt --key=tls.key
```


1. Enable stuff

```bash
microk8s enable rbac hostpath-storage observability metrics-server ingress
```


1. Add the Gitlab Helm repository

```bash
helm repo add gitlab https://charts.gitlab.io/
```


1. Install the Gitlab chart

```bash
kubectl create namespace gitlab
helm install gitlab gitlab/gitlab --namespace gitlab -f gitlab.yaml
```

1. Wait for the pods to be ready

```bash
kubectl get pods -n gitlab
```

1. Get the root password

```bash
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo
```


Then open a browser and go to `http://localhost:8080` and log in with the root password.






# Destroy gitlab 

```bash
helm uninstall gitlab
kubectl delete pvc -l release=gitlab
kubectl delete pv -l release=gitlab
```

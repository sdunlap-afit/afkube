



# Setup certificate

https://docs.gitlab.com/charts/installation/tls.html

```bash
kubectl create secret tls gitlab-tls-key --cert=<path/to-full-chain.crt> --key=<path/to.key>
```

# Install GitLab

https://docs.gitlab.com/charts/quickstart/

```bash
helm repo add gitlab https://charts.gitlab.io/
```


```bash
helm install gitlab gitlab/gitlab \
  --set global.hosts.domain=example.com \
  --set certmanager.install=false \
  --set global.ingress.configureCertmanager=false \
  --set global.ingress.tls.secretName=gitlab-tls-key
```
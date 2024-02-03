curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.26.11+k3s2 K3S_TOKEN='care2007care2007' sh -s - server --server https://10.10.250.13:6443

sudo snap install kubectl --classic
sudo snap install helm --classic
sudo ln -s /snap/bin/kubectl /usr/local/bin/kubectl
sudo snap refresh
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
sudo kubectl create namespace cattle-system

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=thedatacare.secure \
  --set bootstrapPassword=care20072007 \
  --set ingress.tls.source=secret \
  --set privateCA=true \
  --set global.cattle.psp.enabled=false


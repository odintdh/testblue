#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
cd /tmp/
echo 'Add azure-devops extension'
az extension add --name azure-devops
echo 'Add awscliv2'
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --bin-dir /usr/bin --install-dir /usr/bin/installationaws/aws-cli --update
echo "Add kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/bin/kubectl
echo "Add kubelogin"
curl -LO "https://github.com/Azure/kubelogin/releases/download/v0.0.29/kubelogin-linux-amd64.zip" -o "kubelogin-linux-amd64.zip"
unzip kubelogin-linux-amd64.zip
install -o root -g root -m 0755 bin/linux_amd64/kubelogin /usr/bin/kubelogin
echo "Add argocd-cli"
curl -LO "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64" -o "argocd"
install -o root -g root -m 0755 argocd-linux-amd64 /usr/bin/argocd
echo "Add argocd rollouts"
curl -LO "https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64" -o "kubectl-argo-rollouts"
install -o root -g root -m 0755 kubectl-argo-rollouts-linux-amd64 /usr/bin/kubectl-argo-rollouts
echo "Add mc client"
curl -LO "https://dl.min.io/client/mc/release/linux-amd64/mc" -o "mc"
install -o root -g root -m 0755 mc /usr/bin/mc
echo "Add kind"
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.17.0/kind-$(uname)-amd64"
install -o root -g root -m 0755 kind /usr/bin/kind
sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
# workaround to execute dconf-update
cp /usr/etc/systemd/system/dconf-update.service /etc/systemd/system/
systemctl unmask dconf-update.service
systemctl enable dconf-update.service

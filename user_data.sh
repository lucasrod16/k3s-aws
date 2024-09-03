#!/bin/bash
set -e
set -x

INSTANCE_IP=$(curl http://checkip.amazonaws.com)

sudo apt-get update -y && sudo apt-get upgrade -y

# https://docs.k3s.io/installation/requirements?os=debian
ufw disable
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.31.0+k3s1" INSTALL_K3S_EXEC="server --write-kubeconfig-mode 0644 --tls-san $INSTANCE_IP" sh -

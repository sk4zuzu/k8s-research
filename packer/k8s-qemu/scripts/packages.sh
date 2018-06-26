#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update -y

apt-get -q install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

apt-get -q install -y --no-install-recommends \
    pv \
    vim mc htop \
    net-tools iproute2 netcat nmap \
    iftop nethogs

curl -fsSL https://download.docker.com/linux/ubuntu/gpg          | apt-key add -
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

add-apt-repository \
   "deb [arch=amd64] https://apt.kubernetes.io/ \
   kubernetes-$(lsb_release -cs) \
   main"

apt-get -q update -y

apt-get -q install -y \
    docker-ce \
    kubelet \
    kubeadm \
    kubectl \
    kubernetes-cni

apt-get -q clean

HELM_VERSION='v2.9.1'

curl -fsSL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    | tar -xz -f- -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

sync

# vim:ts=4:sw=4:et:syn=sh:

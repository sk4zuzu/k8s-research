#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://apt.kubernetes.io/ \
   kubernetes-$(lsb_release -cs) \
   main"

apt-get -q update -y

apt-get -q install -y \
    kubelet \
    kubeadm \
    kubectl \
    kubernetes-cni

apt-get -q clean

kubeadm reset --force
kubeadm config images pull

HELM_VERSION='v2.9.1'

curl -fsSL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    | tar -xz -f- -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

sync

# vim:ts=4:sw=4:et:syn=sh:

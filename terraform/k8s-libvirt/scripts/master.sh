#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

TOKEN=$1
MASTER_IP=$2

kubeadm reset
kubeadm init \
    --token="$TOKEN" \
    --apiserver-advertise-address="$MASTER_IP" \
    --pod-network-cidr="10.244.0.0/16"

cat >/etc/profile.d/kubeconfig.sh <<EOF
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF

source /etc/profile.d/kubeconfig.sh

kubectl create \
    --namespace="kube-system" \
    -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# vim:ts=4:sw=4:et:syn=sh:

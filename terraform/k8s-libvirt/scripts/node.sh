#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

TOKEN=$1
MASTER_IP=$2

kubeadm reset
kubeadm join \
    --token $TOKEN \
    --discovery-token-unsafe-skip-ca-verification \
    $MASTER_IP:6443

cat >/etc/profile.d/kubeconfig.sh <<EOF
export KUBECONFIG=/etc/kubernetes/kubelet.conf
EOF

# vim:ts=4:sw=4:et:syn=sh:
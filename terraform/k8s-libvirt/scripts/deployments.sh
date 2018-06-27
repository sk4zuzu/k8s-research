#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

source /etc/profile.d/kubeconfig.sh

kubectl create \
    serviceaccount \
    --namespace="kube-system" \
    tiller

kubectl create \
    clusterrolebinding \
    tiller-cluster-rule \
    --clusterrole="cluster-admin" \
    --serviceaccount="kube-system:tiller"

helm init \
    --service-account="tiller" \
    --upgrade \
    --wait

helm repo update

helm install stable/docker-registry

# vim:ts=4:sw=4:et:syn=sh:

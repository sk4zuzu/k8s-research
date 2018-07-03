#!/usr/bin/env bash

: ${COMMAND:=$1}

set -o errexit -o nounset -o pipefail
set -x

source /etc/profile.d/kubeconfig.sh

function helm_init {
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
}

function helm_install {
    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm repo update

    for SCRIPT in /tmp/helm.d/*.sh; do
        chmod +x $SCRIPT && $SCRIPT
    done
}

function helm_purge {
    helm delete $(helm ls --short)
}

case $COMMAND in
    init)
        helm_init
    ;;
    install)
        helm_install
    ;;
    purge)
        helm_purge
    ;;
    *)
        echo "FATAL: command required: $0 <init | install | purge>"
        exit 1
    ;;
esac

# vim:ts=4:sw=4:et:syn=sh:

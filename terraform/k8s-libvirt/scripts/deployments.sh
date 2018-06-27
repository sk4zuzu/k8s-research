#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

kubectl rollout \
    status \
    --namespace="kube-system" \
    --watch="true" \
     deployment/tiller-deploy

helm repo update

helm install stable/docker-registry

# vim:ts=4:sw=4:et:syn=sh:

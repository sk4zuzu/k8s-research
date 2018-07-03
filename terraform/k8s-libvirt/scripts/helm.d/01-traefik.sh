#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

helm install stable/traefik \
    --wait \
    --name="traefik" \
    --namespace="kube-system" \
    -f- <<-EOF
serviceType: NodePort
externalTrafficPolicy: Cluster
replicas: 2
rbac:
  enabled: true
ssl:
  enabled: true
acme:
  enabled: false
deployment:
  hostPort:
    httpEnabled: true
    httpsEnabled: true
EOF

# vim:ts=4:sw=4:et:syn=sh:

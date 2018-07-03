#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

helm install stable/docker-registry \
    --wait \
    --name="registry" \
    -f- <<-EOF
replicaCount: 1
ingress:
  enabled: true
  hosts:
    - registry.svc.k8s.local
  annotations:
    kubernetes.io/ingress.class: traefik
persistence:
  enabled: false
storage: filesystem
EOF

# vim:ts=4:sw=4:et:syn=sh:

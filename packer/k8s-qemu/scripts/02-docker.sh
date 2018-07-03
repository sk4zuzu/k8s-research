#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -q update -y

apt-get -q install -y \
    docker-ce

apt-get -q clean

cat >/etc/docker/daemon.json <<-EOF
{"insecure-registries":["registry.svc.k8s.local"]}
EOF

sync

# vim:ts=4:sw=4:et:syn=sh:

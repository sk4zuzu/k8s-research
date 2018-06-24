#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

which docker packer

VERSION="16.04"
IMAGE="ubuntu-$VERSION-server-cloudimg-amd64-disk1.img"
CHECKSUM="d4117cab734a48a455377b6ba8ffa427ef5f4509dae79141fb1167e4189f9e88"

DISK_SIZE="$((8*1024))"

CLOUD_CONFIG="
#cloud-config
password: ubuntu
ssh_pwauth: true
chpasswd:
  expire: false
"

function cleanup {
    if [ -f $IMAGE.iso ]; then
        rm -f $IMAGE.iso
    fi
}

trap cleanup EXIT

echo ">>> prepare temporary docker image <<<"

docker build -t $IMAGE scripts/ -f- <<EOF
FROM ubuntu:$VERSION

RUN apt-get -q update -y \
 && apt-get -q install -y --no-install-recommends cloud-utils

CMD /bin/bash
EOF

echo ">>> generate cloud-init iso image with config <<<"

docker run --rm -i $IMAGE /bin/bash -s >$IMAGE.iso <<EOF
cloud-localds /dev/stdout <(echo "$CLOUD_CONFIG")
EOF

echo ">>> modify source disk image <<<"

packer build -force - <<EOF
{
  "builders": [
    {
      "type": "qemu",
      "headless": "true",

      "disk_image": "true",
      "iso_url": "https://cloud-images.ubuntu.com/releases/$VERSION/release/$IMAGE",
      "iso_checksum": "$CHECKSUM",
      "iso_checksum_type": "sha256",

      "disk_size": "$DISK_SIZE",

      "qemuargs": [
        ["-fda", "$IMAGE.iso"]
      ],

      "ssh_username": "ubuntu",
      "ssh_password": "ubuntu",

      "output_directory": "$IMAGE",
      "vm_name": "qcow2"
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "script": "scripts/packages.sh",
      "execute_command": "sudo '{{ .Path }}'"
    }
  ]
}
EOF

echo ">>> done <<<"

# vim:ts=4:sw=4:et:syn=sh:

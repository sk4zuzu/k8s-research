
FROM hashicorp/packer:full

RUN apk --no-cache add qemu-system-x86_64 qemu-img docker

WORKDIR /packer

ENTRYPOINT ["/bin/sh"]

# vim:ts=2:sw=2:et:syn=dockerfile:

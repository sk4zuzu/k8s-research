
FROM hashicorp/terraform:full

RUN apk --no-cache add libvirt-client cdrkit openssh-client rsync curl

RUN apk --no-cache add --virtual .build-deps linux-headers musl-dev libvirt-dev gcc \
 && go get github.com/terraform-providers/terraform-provider-null \
 && go get github.com/dmacvicar/terraform-provider-libvirt \
 && go get github.com/mcuadros/terraform-provider-helm \
 && apk --no-cache del .build-deps

WORKDIR /terraform

ENTRYPOINT ["/bin/sh"]

# vim:ts=2:sw=2:et:syn=dockerfile:

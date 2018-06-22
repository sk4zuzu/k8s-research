
FROM hashicorp/terraform:full

RUN apk --no-cache add libvirt-client cdrkit

RUN apk --no-cache add --virtual .build-deps linux-headers musl-dev libvirt-dev gcc \
 && go get github.com/dmacvicar/terraform-provider-libvirt \
 && apk --no-cache del .build-deps

RUN mkdir -p $HOME/.terraform.d/plugins/ \
 && ln -s $GOPATH/bin/terraform-provider-libvirt $HOME/.terraform.d/plugins/

WORKDIR /

ENTRYPOINT ["/bin/sh"]

# vim:ts=2:sw=2:et:syn=dockerfile:

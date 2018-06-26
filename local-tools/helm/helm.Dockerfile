
FROM alpine:3.7

RUN apk --no-cache add curl

ENV KUBECTL_VERSION='v1.10.5' \
    HELM_VERSION='v2.9.1'

RUN curl -fsSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
         -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    | tar -xz -f- linux-amd64/helm \
 && mv linux-amd64/helm /usr/local/bin \
 && chmod +x /usr/local/bin/helm

WORKDIR /helm

ENTRYPOINT ["/bin/sh"]

# vim:ts=2:sw=2:et:syn=dockerfile:

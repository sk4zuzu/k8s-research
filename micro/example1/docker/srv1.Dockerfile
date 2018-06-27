FROM golang:1.10-alpine3.7 as build

RUN apk --no-cache add protobuf

RUN apk --no-cache add git \
 && go get github.com/Masterminds/glide

ENV SOURCE ${GOPATH}/src/github.com/sk4zuzu/k8s-research/micro/example1

COPY glide.* ${SOURCE}/

RUN cd ${SOURCE}/ && glide install \
 && cd ${SOURCE}/vendor/github.com/micro/protobuf/protoc-gen-go/ && go build \
 && mv ${SOURCE}/vendor/github.com/micro/protobuf/protoc-gen-go/protoc-gen-go ${GOPATH}/bin

COPY proto/ ${SOURCE}/proto/
COPY srv1/ ${SOURCE}/srv1/

RUN cd ${SOURCE}/srv1/ \
 && go generate \
 && go build

RUN mv ${SOURCE}/srv1/srv1 /usr/local/bin

FROM alpine:3.7

COPY --from=build /usr/local/bin/srv1 /usr/local/bin/

CMD /usr/local/bin/srv1
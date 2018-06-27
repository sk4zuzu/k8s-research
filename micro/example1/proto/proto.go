package proto

//go:generate protoc -I$GOPATH/src --go_out=plugins=micro:$GOPATH/src $GOPATH/src/github.com/sk4zuzu/k8s-research/micro/example1/proto/greeter/greeter.proto

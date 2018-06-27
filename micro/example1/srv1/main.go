package main

//go:generate go generate github.com/sk4zuzu/k8s-research/micro/example1/proto

import (
	"context"

	log "github.com/sirupsen/logrus"

	micro "github.com/micro/go-micro"

	"github.com/sk4zuzu/k8s-research/micro/example1/proto/greeter"

	_ "github.com/micro/go-plugins/registry/nats"
	_ "github.com/micro/go-plugins/transport/nats"
)

const serviceName = "example1.srv1"

type Greeter struct{}

func (g *Greeter) Hello(ctx context.Context, req *greeter.HelloRequest, rsp *greeter.HelloResponse) error {
	log.WithFields(log.Fields{
		"srv":         serviceName,
		"handler":     "Greeter.Hello",
		"req.GetName": req.GetName(),
	}).Info("")

	rsp.Greeting = "Hello, " + req.GetName()

	log.WithFields(log.Fields{
		"srv":             serviceName,
		"handler":         "Greeter.Hello",
		"rsp.GetGreeting": rsp.GetGreeting(),
	}).Debug("")

	return nil
}

func main() {
	log.WithFields(log.Fields{
		"srv": serviceName,
	}).Info("Starting...")

	service := micro.NewService(
		micro.Name(serviceName),
	)

	service.Init()

	greeter.RegisterGreeterHandler(service.Server(), new(Greeter))

	log.WithFields(log.Fields{
		"srv": serviceName,
	}).Fatal(service.Run())
}

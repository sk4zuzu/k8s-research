package main

//go:generate go generate github.com/sk4zuzu/k8s-research/micro/example1/proto

import (
	"context"

	log "github.com/sirupsen/logrus"

	"github.com/gin-gonic/gin"
	"github.com/micro/go-micro/client"
	web "github.com/micro/go-web"

	"github.com/sk4zuzu/k8s-research/micro/example1/proto/greeter"

	_ "github.com/micro/go-plugins/registry/nats"
	_ "github.com/micro/go-plugins/transport/nats"
)

const serviceName = "example1.api"

type Greeter struct{}

var (
	cl greeter.GreeterClient
)

func (g *Greeter) Hello(c *gin.Context) {
	name := c.Param("name")

	log.WithFields(log.Fields{
		"srv":     serviceName,
		"handler": "Greeter.Hello",
		"name":    name,
	}).Info("")

	rsp, err := cl.Hello(context.TODO(), &greeter.HelloRequest{
		Name: name,
	})

	if err != nil {
		c.JSON(500, err)
	}

	log.WithFields(log.Fields{
		"srv":             serviceName,
		"handler":         "Greeter.Hello",
		"rsp.GetGreeting": rsp.GetGreeting(),
	}).Debug("")

	c.JSON(200, rsp)
}

func main() {
	log.WithFields(log.Fields{
		"srv": serviceName,
	}).Info("Starting...")

	service := web.NewService(
		web.Name(serviceName),
		web.Address(":6969"),
	)

	service.Init()

	cl = greeter.NewGreeterClient("example1.srv2", client.DefaultClient)

	g := new(Greeter)

	router := gin.Default()
	router.GET("/greeter/:name", g.Hello)

	service.Handle("/", router)

	log.WithFields(log.Fields{
		"srv": serviceName,
	}).Fatal(service.Run())
}

package main

import (
	"log"

	"github.com/hashicorp/vault/sdk/plugin"
)

func main() {
	err := plugin.Serve(&plugin.ServeOpts{
		BackendFactoryFunc: backendFactory,
	})
	if err != nil {
		log.Fatalf("Error starting plugin: %v", err)
	}
}

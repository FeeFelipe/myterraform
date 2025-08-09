package main

import (
	"context"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

type myBackend struct {
	*framework.Backend
}

func backendFactory(_ context.Context, conf *logical.BackendConfig) (logical.Backend, error) {
	b := &myBackend{}

	b.Backend = &framework.Backend{
		Help: "Simple custom Vault plugin without external dependencies",
		BackendType: logical.TypeLogical,
		Paths: framework.PathAppend(
			pathConfig(b),
			pathCreds(b),
		),
	}

	if err := b.Setup(context.Background(), conf); err != nil {
		return nil, err
	}
	return b, nil
}

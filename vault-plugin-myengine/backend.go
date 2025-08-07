package main

import (
	"context"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

func backendFactory(_ context.Context, conf *logical.BackendConfig) (logical.Backend, error) {
	b := &framework.Backend{
		Help: "Simple custom Vault plugin without external dependencies",
		Paths: framework.PathAppend(
        	pathConfig(),
        	pathSecret(),
        ),
		BackendType: logical.TypeLogical,
	}
	if err := b.Setup(context.Background(), conf); err != nil {
		return nil, err
	}
	return b, nil
}

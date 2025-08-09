package main

import (
	"context"
	"os"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

func pathCreds(b *myBackend) []*framework.Path {
	return []*framework.Path{
		{
			Pattern: "creds",
			HelpSynopsis: `Return AWS-like credentials for testing/integration.`,
			Operations: map[logical.Operation]framework.OperationHandler{
				logical.ReadOperation: &framework.PathOperation{
					Callback: b.handleCredsRead,
					Summary:  "Read static credentials (from env or test defaults).",
				},
			},
		},
	}
}

func (b *myBackend) handleCredsRead(ctx context.Context, req *logical.Request, _ *framework.FieldData) (*logical.Response, error) {
	entry, _ := req.Storage.Get(ctx, configStorageKey)
	if entry == nil {
		return &logical.Response{
			Data: map[string]any{
				"error": "myengine/config not set",
			},
		}, nil
	}

	ak := os.Getenv("AWS_ACCESS_KEY_ID")
	sk := os.Getenv("AWS_SECRET_ACCESS_KEY")
	if ak == "" {
		ak = "test"
	}
	if sk == "" {
		sk = "test"
	}

	return &logical.Response{
		Data: map[string]any{
			"access_key": ak,
			"secret_key": sk,
		},
	}, nil
}

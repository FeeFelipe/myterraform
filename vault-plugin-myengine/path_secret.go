package main

import (
	"context"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

func pathSecret() []*framework.Path {
	return []*framework.Path{
		{
			Pattern: "secret",
			Operations: map[logical.Operation]framework.OperationHandler{
				logical.ReadOperation: &framework.PathOperation{
					Callback: handleSecretRead,
				},
			},
		},
	}
}

func handleSecretRead(ctx context.Context, req *logical.Request, data *framework.FieldData) (*logical.Response, error) {
	return &logical.Response{
		Data: map[string]interface{}{
			"secret": "this is a static secret",
		},
	}, nil
}

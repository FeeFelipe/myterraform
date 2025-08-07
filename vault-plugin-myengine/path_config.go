package main

import (
	"context"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

func pathConfig() []*framework.Path {
	return []*framework.Path{
		{
			Pattern: "config",
			Fields: map[string]*framework.FieldSchema{
				"message": {
					Type:        framework.TypeString,
					Description: "A custom message",
				},
			},
			Operations: map[logical.Operation]framework.OperationHandler{
				logical.CreateOperation: &framework.PathOperation{
					Callback: handleConfigWrite,
				},
			},
		},
	}
}

func handleConfigWrite(ctx context.Context, req *logical.Request, data *framework.FieldData) (*logical.Response, error) {
	message := data.Get("message").(string)
	return &logical.Response{
		Data: map[string]interface{}{
			"stored_message": message,
		},
	}, nil
}

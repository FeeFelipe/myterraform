package main

import (
	"context"
	"fmt"

	"github.com/hashicorp/vault/sdk/framework"
	"github.com/hashicorp/vault/sdk/logical"
)

const configStorageKey = "config"

type engineConfig struct {
	BucketSuffix string `json:"bucket_suffix"`
}

func pathConfig(b *myBackend) []*framework.Path {
	return []*framework.Path{
		{
			Pattern: "config",
			HelpSynopsis: `Write or read myengine configuration.`,
			Fields: map[string]*framework.FieldSchema{
				"bucket_suffix": {
					Type:        framework.TypeString,
					Description: "Suffix used to compose bucket names.",
				},
			},
			Operations: map[logical.Operation]framework.OperationHandler{
				logical.CreateOperation: &framework.PathOperation{
					Callback: b.handleConfigWrite,
					Summary:  "Create or update myengine configuration.",
				},
				logical.UpdateOperation: &framework.PathOperation{
					Callback: b.handleConfigWrite,
					Summary:  "Create or update myengine configuration.",
				},
				logical.ReadOperation: &framework.PathOperation{
					Callback: b.handleConfigRead,
					Summary:  "Read myengine configuration.",
				},
			},
		},
	}
}

func (b *myBackend) handleConfigWrite(ctx context.Context, req *logical.Request, data *framework.FieldData) (*logical.Response, error) {
	bucketSuffixRaw, ok := data.GetOk("bucket_suffix")
	if !ok {
		return logical.ErrorResponse("missing required field 'bucket_suffix'"), nil
	}
	cfg := &engineConfig{
		BucketSuffix: bucketSuffixRaw.(string),
	}
	entry, err := logical.StorageEntryJSON(configStorageKey, cfg)
	if err != nil {
		return nil, fmt.Errorf("failed to serialize config: %w", err)
	}
	if err := req.Storage.Put(ctx, entry); err != nil {
		return nil, fmt.Errorf("failed to store config: %w", err)
	}

	return &logical.Response{
		Data: map[string]any{
			"bucket_suffix": cfg.BucketSuffix,
			"stored":        true,
		},
	}, nil
}

func (b *myBackend) handleConfigRead(ctx context.Context, req *logical.Request, _ *framework.FieldData) (*logical.Response, error) {
	entry, err := req.Storage.Get(ctx, configStorageKey)
	if err != nil {
		return nil, fmt.Errorf("failed to read config: %w", err)
	}
	if entry == nil {
		return nil, nil
	}
	var cfg engineConfig
	if err := entry.DecodeJSON(&cfg); err != nil {
		return nil, fmt.Errorf("failed to decode config: %w", err)
	}
	return &logical.Response{
		Data: map[string]any{
			"bucket_suffix": cfg.BucketSuffix,
		},
	}, nil
}

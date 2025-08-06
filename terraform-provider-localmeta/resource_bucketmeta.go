package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)

func resourceLocalMetaBucket() *schema.Resource {
	return &schema.Resource{
		Create: resourceLocalMetaBucketCreate,
		Read:   resourceLocalMetaBucketRead,
		Delete: resourceLocalMetaBucketDelete,

		Schema: map[string]*schema.Schema{
			"bucket_name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Name of the S3 bucket",
				ForceNew:    true,
			},
			"tags": {
				Type:        schema.TypeMap,
				Optional:    true,
				Elem:        &schema.Schema{Type: schema.TypeString},
				Description: "Tags associated with the bucket",
			},
			"metadata_file": {
				Type:        schema.TypeString,
				Computed:    true,
				Description: "Path to the generated JSON metadata file",
			},
		},
	}
}

func resourceLocalMetaBucketCreate(d *schema.ResourceData, m interface{}) error {
	bucketName := d.Get("bucket_name").(string)
	tags := d.Get("tags").(map[string]interface{})

	metadata := map[string]interface{}{
		"bucket_name": bucketName,
		"tags":        tags,
	}

	outputDir := m.(*schema.Provider).Schema["output_dir"].Default.(string)
	filePath := filepath.Join(outputDir, fmt.Sprintf("%s.json", bucketName))

	file, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("failed to create metadata file: %w", err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(metadata); err != nil {
		return fmt.Errorf("failed to write metadata JSON: %w", err)
	}

	d.SetId(bucketName)
	d.Set("metadata_file", filePath)
	return nil
}

func resourceLocalMetaBucketRead(d *schema.ResourceData, m interface{}) error {
	// For simplicity, we won't re-read the JSON file.
	// Resource always considered present if file exists.
	return nil
}

func resourceLocalMetaBucketDelete(d *schema.ResourceData, m interface{}) error {
	filePath := d.Get("metadata_file").(string)
	if _, err := os.Stat(filePath); err == nil {
		os.Remove(filePath)
	}
	d.SetId("")
	return nil
}

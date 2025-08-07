package resources

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"regexp"

	"github.com/hashicorp/terraform-plugin-log/tflog"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/validation"
	"local/localmeta/config"
)

func ResourceLocalMetaBucket() *schema.Resource {
	return &schema.Resource{
		Create: resourceLocalMetaBucketCreate,
		Read:   resourceLocalMetaBucketRead,
		Delete: resourceLocalMetaBucketDelete,

		Schema: map[string]*schema.Schema{
			"bucket_name": {
				Type:         schema.TypeString,
				Required:     true,
				ForceNew:     true,
				Description:  "Name of the S3 bucket",
				ValidateFunc: validation.StringMatch(
					regexp.MustCompile(`^[a-z0-9\-]+$`),
					"must contain only lowercase letters, numbers, and hyphens",
				),
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

func resourceLocalMetaBucketCreate(d *schema.ResourceData, meta interface{}) error {
	cfg := meta.(*config.Config)

	bucketName := d.Get("bucket_name").(string)
	tags := d.Get("tags").(map[string]interface{})

	metadata := map[string]interface{}{
		"bucket_name": bucketName,
		"tags":        tags,
	}

	if err := os.MkdirAll(cfg.OutputDir, 0755); err != nil {
		return fmt.Errorf("failed to create output directory: %w", err)
	}

	filePath := filepath.Join(cfg.OutputDir, fmt.Sprintf("%s.json", bucketName))

	tflog.Debug(nil, "Creating metadata file", map[string]interface{}{
		"path": filePath,
	})

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

func resourceLocalMetaBucketRead(d *schema.ResourceData, meta interface{}) error {
	// No-op read; assumes the file remains valid after creation
	return nil
}

func resourceLocalMetaBucketDelete(d *schema.ResourceData, meta interface{}) error {
	filePath := d.Get("metadata_file").(string)

	tflog.Debug(nil, "Deleting metadata file", map[string]interface{}{
		"path": filePath,
	})

	if err := os.Remove(filePath); err != nil && !os.IsNotExist(err) {
		return fmt.Errorf("failed to delete metadata file: %w", err)
	}

	d.SetId("")
	return nil
}

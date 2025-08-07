package provider

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"local/localmeta/config"
	"local/localmeta/resources"
)

func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"output_dir": {
				Type:        schema.TypeString,
				Optional:    true,
				Default:     "./",
				Description: "Directory where JSON metadata files will be written",
			},
		},
		ConfigureFunc: configureProvider,
		ResourcesMap: map[string]*schema.Resource{
			"localmeta_bucket": resources.ResourceLocalMetaBucket(),
		},
	}
}

func configureProvider(d *schema.ResourceData) (interface{}, error) {
	outputDir := d.Get("output_dir").(string)
	return &config.Config{OutputDir: outputDir}, nil
}

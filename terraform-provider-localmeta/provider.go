package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)

func Provider() *schema.Provider {
	return &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"localmeta_bucket": resourceLocalMetaBucket(),
		},
		Schema: map[string]*schema.Schema{
			"output_dir": {
				Type:        schema.TypeString,
				Optional:    true,
				Default:     "./",
				Description: "Directory where JSON metadata files will be written",
			},
		},
	}
}

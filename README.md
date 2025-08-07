# Terraform + LocalStack + Nomad + Custom Provider (localmeta)

This project demonstrates a **local development environment** for AWS using **LocalStack**, **Nomad**, and **Terraform** with a **custom Terraform provider** that generates local JSON metadata.

---

## Project Structure

```
.
├─ docker-compose.yml                # Local environment orchestration
├─ Dockerfile.terraform               # Multi-stage build for Terraform + provider
├─ jobs/                              # Nomad jobs (example)
├─ init/                              # LocalStack init scripts
├─ localstack-data/                   # LocalStack persistent data
├─ aws/                               # AWS CLI config for LocalStack
├─ terraform-localstack/              # Terraform project
│  ├─ main.tf
│  ├─ providers.tf
│  ├─ variables.tf
│  ├─ outputs.tf
│  ├─ dev.tfvars
│  └─ modules/
│      ├─ s3/
│      ├─ sqs/
│      └─ iam-user/
└─ terraform-provider-localmeta/      # Custom Terraform provider (Go)
   ├─ main.go
   ├─ provider.go
   ├─ resource_bucketmeta.go
   └─ go.mod
```

---

## Components

- **Nomad**: Orchestrator for local jobs (optional in this demo)
- **LocalStack**: Simulates AWS services (S3, SQS, DynamoDB)
- **AWS CLI**: Interact with LocalStack endpoints
- **Terraform**: Provision resources locally
- **Local Provider (`localmeta`)**: Generates JSON metadata for S3 buckets

---

## Getting Started

###  Build and start environment

```bash
docker compose up -d --build
```

This will:

1. Compile the custom Terraform provider.
2. Start:
    - Nomad
    - LocalStack
    - AWS CLI container
    - Terraform container

---

### Access the Terraform container

```bash
docker exec -it terraform sh
```

---

### Initialize Terraform

Inside the container:

```bash
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars
```

---

### Verify Resources

- **LocalStack** Web UI: [http://localhost:4566](http://localhost:4566)
- **List S3 buckets**:

```bash
aws --endpoint-url=http://localstack:4566 s3 ls
```

- **Check generated metadata file** (from custom provider):

```bash
/workspace/<bucket_name>.json
```

Example:

```json
{
  "bucket_name": "my-dev-bucket",
  "tags": {
    "Environment": "local",
    "Project": "demo"
  }
}
```

---

## Custom Terraform Provider

- Path: `terraform-provider-localmeta/`
- Module name: `local/localmeta`
- Example usage in Terraform:

```hcl
provider "localmeta" {}

resource "localmeta_bucket" "metadata" {
  bucket_name = module.s3.bucket_name
  tags        = var.default_tags
}
```

When applied, this creates a `<bucket_name>.json` file with the tags and bucket name.

---

## Clean up

```bash
terraform destroy -auto-approve -var-file=dev.tfvars
docker compose down -v
```

---

## Notes

- Compatible with **Terraform 1.9.x**
- Custom provider automatically compiled in Docker build
- All AWS calls point to **LocalStack** (no real AWS charges)

---

**Author:** Felipe Cavalieri
**License:** MIT

# Local Infrastructure Demo – Vault + Custom Plugin + Terraform + LocalStack

This project provides a complete local environment to develop and test infrastructure provisioning workflows **without connecting to a real cloud**.  
It combines a **custom Vault plugin** (`myengine`), a **custom Terraform provider** (`localmeta`), and **LocalStack** to simulate AWS services.

---

## Project Structure

```
.
├── Dockerfile.terraform              # Terraform image with localmeta provider
├── Dockerfile.vault                  # Vault image with myengine plugin
├── docker-compose.yml                # Orchestration for Vault, LocalStack, Terraform
├── aws/credentials                   # AWS CLI credentials for LocalStack
├── init/create-resources.sh          # Init script for LocalStack resources
├── jobs/localstack.nomad              # Example Nomad job
├── localstack-data/                  # LocalStack persistence (cache, logs, tmp)
├── terraform-localstack/              # Terraform project
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── datas.tf
│   ├── resources.tf
│   ├── dev.tfvars
│   └── modules/
│       ├── s3/
│       └── sqs/
├── terraform-provider-localmeta/      # Custom Terraform provider
│   ├── provider/provider.go
│   ├── resources/local_meta_bucket.go
│   ├── config/config.go
│   ├── main.go
│   ├── go.mod
│   └── go.sum
├── vault/                              # Vault init scripts
│   ├── entrypoint.sh
│   └── init-plugin.sh
└── vault-plugin-myengine/              # Custom Vault secrets engine
    ├── backend.go
    ├── path_config.go
    ├── path_creds.go
    ├── main.go
    ├── go.mod
    └── go.sum
```

---

## Components

- **Vault 1.15.5** with custom plugin `myengine`
  - Stores `bucket_suffix` and generates credentials on demand.
- **Terraform 1.9.5**
  - Uses provider `localmeta` to generate local artifacts (JSON metadata).
- **LocalStack**
  - Simulates AWS services (S3, SQS, IAM, STS) for testing.
- **Docker & Docker Compose**
  - Orchestrates all services for a repeatable local dev setup.
- **Nomad** (optional demo job in `jobs/localstack.nomad`).

---

## How It Works

1. **Vault container** starts with `myengine` plugin built in and registered.
2. Plugin seeds `myengine/config` with `bucket_suffix` (from env var `BUCKET_SUFFIX`).
3. **Terraform** reads `bucket_suffix` and credentials from Vault.
4. Terraform uses **localmeta** provider to generate local artifacts based on secure config.
5. Optional AWS resources are simulated via **LocalStack**.

---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/FeeFelipe/myterraform.git
cd myterraform
```

### 2. Start the environment
```bash
docker compose up --build
```
This will:
- Build Vault image with `myengine` plugin.
- Build Terraform image with `localmeta` provider.
- Start Vault, LocalStack, and Terraform containers.

### 3. Access the Terraform container
```bash
docker exec -it terraform sh
```

### 4. Run Terraform
```bash
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars
```

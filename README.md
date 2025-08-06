# myterraform

I should to use docker to orchestrate the Nomad because my Mac is 2012 and doent support the new OS version, so I need to run the Nomad from the container


aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 sqs list-queues
aws --endpoint-url=http://localhost:4566 dynamodb list-tables


Terraform + LocalStack use case is to simulate AWS S3 and SQS locally for development/testing, without spending money on AWS.

I’ll create a self-contained Terraform module that:

Creates an S3 bucket

Creates an SQS queue

Creates an IAM user with permissions for these resources

Works fully on LocalStack



docker exec -it terraform sh

terraform init
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars






Local AWS Environment with Nomad, LocalStack, Terraform, and AWS CLI
This project provides a fully local AWS development environment using:

Nomad – Lightweight container orchestrator

LocalStack – AWS services emulator

Terraform – Infrastructure as Code for AWS resources

AWS CLI – For testing AWS services locally

It is designed to develop and test cloud-native applications locally without incurring AWS costs.

Features
🐳 Docker Compose environment with:

Nomad in dev mode (single node)

LocalStack with S3, SQS, DynamoDB

AWS CLI container for local testing

Terraform container for infrastructure automation

✅ Persistent LocalStack storage

✅ Preconfigured dummy AWS credentials (test/test)

✅ Modular Terraform setup for S3, SQS, IAM user

Project Structure
bash
Copiar
Editar
.
├─ docker-compose.yml        # Defines Nomad, LocalStack, Terraform, AWS CLI
├─ jobs/                     # Example Nomad jobs
├─ init/                     # Scripts auto-executed by LocalStack
├─ localstack-data/          # Persistent LocalStack data
├─ aws/credentials           # Dummy AWS credentials
└─ terraform-localstack/     # Terraform configuration
├─ main.tf
├─ providers.tf
├─ variables.tf
├─ outputs.tf
├─ dev.tfvars
└─ modules/
├─ s3/
├─ sqs/
└─ iam-user/
1️⃣ Start the Environment
Start all services in the background:

bash
Copiar
Editar
docker compose up -d
Check running containers:

bash
Copiar
Editar
docker ps
Access:

Nomad UI: http://localhost:4646

LocalStack endpoint: http://localhost:4566

2️⃣ Test AWS CLI
The AWS CLI container comes pre-configured with dummy credentials.
Enter the container:

bash
Copiar
Editar
docker exec -it awscli bash
List all S3 buckets in LocalStack:

bash
Copiar
Editar
aws --endpoint-url=http://localstack:4566 s3 ls
Create a bucket and a queue:

bash
Copiar
Editar
aws --endpoint-url=http://localstack:4566 s3 mb s3://my-local-bucket
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name my-local-queue
3️⃣ Use Terraform for Local AWS Resources
Enter the Terraform container:

bash
Copiar
Editar
docker exec -it terraform sh
Initialize the Terraform project:

bash
Copiar
Editar
terraform init
Preview changes with your dev environment variables:

bash
Copiar
Editar
terraform plan -var-file=dev.tfvars
Apply changes to LocalStack:

bash
Copiar
Editar
terraform apply -auto-approve -var-file=dev.tfvars
Verify resources with AWS CLI:

bash
Copiar
Editar
aws --endpoint-url=http://localstack:4566 s3 ls
aws --endpoint-url=http://localstack:4566 sqs list-queues
aws --endpoint-url=http://localstack:4566 iam list-users
4️⃣ Example Terraform Modules
This project includes modular Terraform code to provision:

S3 bucket

SQS queue

IAM user with S3/SQS access

Modules are reusable and environment-aware via .tfvars files.

5️⃣ Stop the Environment
To stop and remove all containers:

bash
Copiar
Editar
docker compose down
To remove persistent LocalStack data:

bash
Copiar
Editar
docker compose down -v
rm -rf localstack-data

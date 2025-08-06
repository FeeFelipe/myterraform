#!/bin/bash
set -e

echo "Creating LocalStack..."

aws --endpoint-url=http://localstack:4566 s3 mb s3://my-bucket

aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name my-queue

aws --endpoint-url=http://localstack:4566 dynamodb create-table \
    --table-name MyTable \
    --attribute-definitions AttributeName=Id,AttributeType=S \
    --key-schema AttributeName=Id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo "LocalStack created!"

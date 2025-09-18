#!/bin/bash
# A script to seed the DynamoDB table with initial data.

TABLE_NAME="cloud-dictionary-dev"
DATA_FILE="dictionary_dataset.json"

echo "Seeding database: ${TABLE_NAME}"

aws dynamodb batch-write-item \
  --request-items file://${DATA_FILE} \
  --region us-east-1

echo "Seeding complete."
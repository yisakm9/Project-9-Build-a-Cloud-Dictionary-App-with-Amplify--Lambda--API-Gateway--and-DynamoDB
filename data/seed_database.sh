#!/bin/bash
# A script to seed a DynamoDB table with initial data.
# It accepts the table name as the first argument.

set -e # Exit immediately if a command exits with a non-zero status.

TABLE_NAME="$1"

# --- THIS IS THE FIX ---
# Get the directory where the script is located.
SCRIPT_DIR=$(dirname "$0")
TEMPLATE_FILE="$SCRIPT_DIR/dictionary_data_template.json"
# --- END OF FIX ---

REGION="us-east-1"

if [ -z "$TABLE_NAME" ];
  then
    echo "Error: Table name not provided. Usage: ./seed_database.sh <table-name>"
    exit 1
fi

echo "Seeding database: ${TABLE_NAME} with template: ${TEMPLATE_FILE}"

# Use jq to dynamically insert the table name into the request structure
# and pipe it directly to the aws cli command.
jq --arg table "$TABLE_NAME" '{($table): .}' "$TEMPLATE_FILE" | aws dynamodb batch-write-item \
  --request-items file:///dev/stdin \
  --region "$REGION"

echo "Seeding complete."
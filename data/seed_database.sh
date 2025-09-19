#!/bin/bash
# A script to seed a DynamoDB table with initial data.
# It accepts the table name as the first argument.

set -e # Exit immediately if a command exits with a non-zero status.

# --- THIS IS THE FIX ---
# This block makes the script aware of its own location.
# It ensures that it can always find files located next to it.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TEMPLATE_FILE="$SCRIPT_DIR/dictionary_data_template.json"
# --- END OF FIX ---

TABLE_NAME="$1"
REGION="us-east-1"

if [ -z "$TABLE_NAME" ];
  then
    echo "Error: Table name not provided. Usage: ./seed_database.sh <table-name>"
    exit 1
fi

echo "Seeding database: ${TABLE_NAME}"

# Use jq to dynamically insert the table name into the request structure
# and pipe it directly to the aws cli command.
jq --arg table "$TABLE_NAME" '{($table): .}' "$TEMPLATE_FILE" | aws dynamodb batch-write-item \
  --request-items file:///dev/stdin \
  --region "$REGION"

echo "Seeding complete."
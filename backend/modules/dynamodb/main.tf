# Creates the DynamoDB table for the dictionary
resource "aws_dynamodb_table" "dictionary_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # Cost-effective for serverless/unpredictable workloads
  hash_key     = "term"

  attribute {
    name = "term"
    type = "S" # S for String
  }
}
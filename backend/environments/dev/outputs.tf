output "dynamodb_table_name" {
  description = "Name of the dictionary DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the dictionary DynamoDB table"
  value       = module.dynamodb.table_arn
}
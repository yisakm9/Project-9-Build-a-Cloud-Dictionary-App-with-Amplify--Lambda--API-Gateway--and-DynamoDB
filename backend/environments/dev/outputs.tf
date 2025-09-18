output "dynamodb_table_name" {
  description = "Name of the dictionary DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the dictionary DynamoDB table"
  value       = module.dynamodb.table_arn
}

output "api_invoke_url" {
  description = "Base URL to invoke the API Gateway"
  value       = module.api_gateway.invoke_url
}
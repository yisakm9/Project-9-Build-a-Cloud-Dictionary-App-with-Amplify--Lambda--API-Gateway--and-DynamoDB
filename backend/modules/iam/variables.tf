variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table to grant access to"
  type        = string
}
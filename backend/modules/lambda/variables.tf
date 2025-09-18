variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for the function to assume"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table for the environment variable"
  type        = string
}
variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "lambda_function_arn" {
  description = "The standard ARN of the Lambda function (for permissions)"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The invocation ARN of the Lambda function (for integration)"
  type        = string
}
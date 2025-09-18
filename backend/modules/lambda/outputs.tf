output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.dictionary_lambda.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.dictionary_lambda.function_name
}
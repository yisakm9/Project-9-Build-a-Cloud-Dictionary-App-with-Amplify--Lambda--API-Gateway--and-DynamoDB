output "invoke_url" {
  description = "The base invoke URL for the API stage"
  value       = aws_api_gateway_stage.api_stage.invoke_url
}
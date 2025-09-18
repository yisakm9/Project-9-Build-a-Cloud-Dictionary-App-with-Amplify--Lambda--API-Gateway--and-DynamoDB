# Create the REST API
resource "aws_api_gateway_rest_api" "dictionary_api" {
  name        = var.api_name
  description = "API for the Cloud Dictionary application"
}

# Create the resource, e.g., /definition
resource "aws_api_gateway_resource" "definition_resource" {
  rest_api_id = aws_api_gateway_rest_api.dictionary_api.id
  parent_id   = aws_api_gateway_rest_api.dictionary_api.root_resource_id
  path_part   = "definition"
}

# Create a path parameter for the term, e.g., /{term}
resource "aws_api_gateway_resource" "term_resource" {
  rest_api_id = aws_api_gateway_rest_api.dictionary_api.id
  parent_id   = aws_api_gateway_resource.definition_resource.id
  path_part   = "{term}" # This creates a path parameter
}

# Create the GET method for the /{term} resource
resource "aws_api_gateway_method" "get_definition_method" {
  rest_api_id   = aws_api_gateway_rest_api.dictionary_api.id
  resource_id   = aws_api_gateway_resource.term_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create the integration between the GET method and the Lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.dictionary_api.id
  resource_id             = aws_api_gateway_resource.term_resource.id
  http_method             = aws_api_gateway_method.get_definition_method.http_method
  integration_http_method = "POST" # Must be POST for Lambda proxy integration
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}

# Create a deployment to make the API callable
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.dictionary_api.id

  # A lifecycle block ensures a new deployment is created on any change
  lifecycle {
    create_before_destroy = true
  }

  # This depends on the method and integration being set up first
  depends_on = [aws_api_gateway_integration.lambda_integration]
}

# Create a stage (e.g., 'v1') to host the deployment
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.dictionary_api.id
  stage_name    = "v1"
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  # Restrict the permission to only this specific API's GET method
  source_arn = "${aws_api_gateway_rest_api.dictionary_api.execution_arn}/*/${aws_api_gateway_method.get_definition_method.http_method}${aws_api_gateway_resource.definition_resource.path}${aws_api_gateway_resource.term_resource.path}"
}
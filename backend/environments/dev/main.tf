# Module to create the DynamoDB table
module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name = "cloud-dictionary-dev"
}

# Module to the  IAM role  for the Lambda
module "iam" {
  source = "../../modules/iam"

  function_name      = "fetch-definition-dev"
  dynamodb_table_arn = module.dynamodb.table_arn
}

# Module to create the Lambda function
module "lambda" {
  source = "../../modules/lambda"

  function_name = "fetch-definition-dev"
  iam_role_arn  = module.iam.role_arn
  table_name    = module.dynamodb.table_name
}
# Module to create the API Gateway
module "api_gateway" {
  source = "../../modules/api_gateway"

  api_name            = "CloudDictionaryAPI-dev"
  lambda_function_arn = module.lambda.function_arn
  lambda_invoke_arn   = module.lambda.invoke_arn
}
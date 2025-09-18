# Module to create the DynamoDB table
module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name = "cloud-dictionary-dev"
}

# Module to create the IAM role for the Lambda
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
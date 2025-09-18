# Package the Lambda source code into a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/fetch_definition"
  output_path = "${path.module}/fetch_definition.zip"
}

# Create the AWS Lambda function
resource "aws_lambda_function" "dictionary_lambda" {
  function_name = var.function_name
  handler       = "main.handler"
  runtime       = "python3.9"
  role          = var.iam_role_arn

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}
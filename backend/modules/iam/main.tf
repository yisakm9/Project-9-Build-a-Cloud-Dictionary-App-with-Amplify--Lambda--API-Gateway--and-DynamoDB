# IAM Role for the Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-exec-role"

  # Trust policy allowing Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy granting necessary permissions
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.function_name}-policy"
  description = "Policy for Lambda to access DynamoDB and CloudWatch Logs"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        # Allow reading from the specific DynamoDB table
        Action = [
          "dynamodb:GetItem"
        ],
        Effect   = "Allow",
        Resource = var.dynamodb_table_arn
      },
      {
        # Allow writing logs to CloudWatch
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
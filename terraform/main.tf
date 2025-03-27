# main.tf
provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "remediation_bucket" {
  bucket = "security-remediation-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "SecurityRemediationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_cloudwatch_event_rule" "guardduty_alerts" {
  name        = "guardduty-security-alerts"
  description = "Triggers for high-severity GuardDuty findings"
  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = [{ numeric = [">=", 7] }]
    }
  })
}

resource "aws_lambda_function" "security_remediation" {
  function_name = "SecurityRemediation"
  s3_bucket     = aws_s3_bucket.remediation_bucket.bucket
  s3_key        = "lambda-zips/security_lambda.zip"
  runtime       = "python3.9"
  handler       = "security_lambda.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      REMEDIATION_BUCKET = aws_s3_bucket.remediation_bucket.bucket
    }
  }
}

resource "aws_iam_role_policy" "remediation_policy" {
  name = "SecurityRemediationPolicy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:UpdateUser",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupEgress",
          "s3:PutObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "guardduty:GetFindings"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_alerts.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.security_remediation.arn
}


# outputs.tf (complete file)
output "lambda_arn" {
  value = aws_lambda_function.security_remediation.arn
}

output "s3_bucket" {
  value = aws_s3_bucket.remediation_bucket.bucket
}

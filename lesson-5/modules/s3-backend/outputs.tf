output "s3_bucket_url" {
  description = "URL of the S3 bucket for Terraform state"
  value       = "https://${aws_s3_bucket.terraform_state.bucket_regional_domain_name}"
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locks"
  value       = aws_dynamodb_table.terraform_locks.name
}

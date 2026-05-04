output "s3_bucket_url" {
  description = "URL of the S3 bucket for Terraform state"
  value       = "https://${aws_s3_bucket.terraform_state.bucket_regional_domain_name}"
}

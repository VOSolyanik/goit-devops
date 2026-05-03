variable "bucket_name" {
  description = "Unique S3 bucket name for Terraform state"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name for Terraform state lock"
  type        = string
  default     = "terraform-locks"
}

variable "tags" {
  description = "Common tags for created resources"
  type        = map(string)
  default     = {}
}

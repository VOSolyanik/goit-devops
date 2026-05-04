variable "bucket_name" {
  description = "Unique S3 bucket name for Terraform state"
  type        = string
}

variable "tags" {
  description = "Common tags for created resources"
  type        = map(string)
  default     = {}
}

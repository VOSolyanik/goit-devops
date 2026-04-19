variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "vpc_name" {
  description = "VPC name tag"
  type        = string
}

variable "tags" {
  description = "Common tags for created resources"
  type        = map(string)
  default     = {}
}

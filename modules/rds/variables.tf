variable "name" {
  description = "Name prefix for RDS or Aurora resources"
  type        = string
}

variable "use_aurora" {
  description = "If true, deploy Aurora cluster; if false, single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "17.2"
}

variable "parameter_group_family_rds" {
  description = "Must match engine major version, e.g. postgres17"
  type        = string
  default     = "postgres17"
}

variable "engine_cluster" {
  type    = string
  default = "aurora-postgresql"
}

variable "engine_version_cluster" {
  type    = string
  default = "15.3"
}

variable "parameter_group_family_aurora" {
  type    = string
  default = "aurora-postgresql15"
}

variable "aurora_replica_count" {
  description = "Number of Aurora read replicas"
  type        = number
  default     = 1
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  description = "GB; only used by standard RDS"
  type        = number
  default     = 20
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "subnet_public_ids" {
  type = list(string)
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  description = "Ignored for Aurora"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Days. 0 = disabled (free-tier RDS). Aurora enforces minimum 1."
  type        = number
  default     = 0
}

variable "parameters" {
  type = map(string)
  default = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

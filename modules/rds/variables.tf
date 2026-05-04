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
  description = "RDS engine (e.g. postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "RDS engine version (e.g. 17.2 for PostgreSQL)"
  type        = string
  default     = "17.2"
}

variable "parameter_group_family_rds" {
  description = "Must match engine major version, e.g. postgres17"
  type        = string
  default     = "postgres17"
}

variable "engine_cluster" {
  description = "Aurora engine type (e.g. aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Aurora engine version (e.g. 15.3 for aurora-postgresql)"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_aurora" {
  description = "Aurora parameter group family matching engine_version_cluster (e.g. aurora-postgresql15)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "aurora_replica_count" {
  description = "Number of Aurora read replicas"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "DB instance class for both RDS and Aurora instances (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "GB; only used by standard RDS"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database (sensitive)"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID of the VPC where the database will be deployed"
  type        = string
}

variable "subnet_private_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "List of public subnet IDs used when publicly_accessible = true"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the database endpoint should be publicly accessible"
  type        = bool
  default     = false
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

variable "db_port" {
  description = "Port the database listens on; used in the security group ingress rule (PostgreSQL: 5432, MySQL: 3306)"
  type        = number
  default     = 5432
}

variable "parameters" {
  description = "Map of database engine parameters to apply via the parameter group"
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096"
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block — restricts RDS security group ingress to internal traffic only"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}

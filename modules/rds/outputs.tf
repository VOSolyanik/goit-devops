output "db_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}

output "security_group_id" {
  value = aws_security_group.rds.id
}

output "standard_endpoint" {
  description = "RDS address (null when use_aurora=true)"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].address
}

output "standard_port" {
  description = "RDS port (null when use_aurora=true)"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].port
}

output "standard_identifier" {
  value = var.use_aurora ? null : aws_db_instance.standard[0].identifier
}

output "aurora_cluster_endpoint" {
  description = "Aurora writer endpoint (null when use_aurora=false)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint (null when use_aurora=false)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_port" {
  value = var.use_aurora ? aws_rds_cluster.aurora[0].port : null
}

output "aurora_cluster_identifier" {
  value = var.use_aurora ? aws_rds_cluster.aurora[0].cluster_identifier : null
}

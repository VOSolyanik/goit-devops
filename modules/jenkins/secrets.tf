data "aws_secretsmanager_secret_version" "jenkins_admin" {
  secret_id = var.admin_secret_name
}

locals {
  jenkins_admin = jsondecode(data.aws_secretsmanager_secret_version.jenkins_admin.secret_string)
}

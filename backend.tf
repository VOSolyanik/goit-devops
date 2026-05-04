terraform {
  backend "s3" {
    bucket         = "goit-devops-final-project-tfstate-451790114144"
    key            = "final-project/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

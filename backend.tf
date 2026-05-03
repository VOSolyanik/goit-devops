terraform {
  backend "s3" {
    bucket         = "goit-devops-lesson-8-9-tfstate-451790114144"
    key            = "lesson-8-9/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-8-9"
    encrypt        = true
  }
}

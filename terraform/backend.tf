terraform {
  backend "s3" {
    bucket         = "goit-devops-lesson-7-tfstate-451790114144"
    key            = "lesson-7/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-7"
    encrypt        = true
  }
}

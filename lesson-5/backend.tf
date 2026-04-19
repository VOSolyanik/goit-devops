terraform {
	backend "s3" {
		bucket         = "goit-devops-lesson-5-tfstate-451790114144"
		key            = "lesson-5/terraform.tfstate"
		region         = "us-east-1"
		dynamodb_table = "terraform-locks"
		encrypt        = true
	}
}

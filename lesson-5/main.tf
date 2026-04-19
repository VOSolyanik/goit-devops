terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  common_tags = {
    Project = "goit-devops-lesson-5"
    Managed = "terraform"
  }
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-devops-lesson-5-tfstate-451790114144"
  table_name  = "terraform-locks"
  tags        = local.common_tags
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "lesson-5-vpc"
  tags               = local.common_tags
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
  tags         = local.common_tags
}

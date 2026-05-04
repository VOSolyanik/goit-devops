terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "main" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = var.rds_secret_name
}

data "aws_secretsmanager_secret_version" "grafana" {
  secret_id = var.grafana_secret_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}

locals {
  common_tags = {
    Project = "goit-devops-final-project"
    Managed = "terraform"
  }
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-devops-final-project-tfstate-451790114144"
  tags        = local.common_tags
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "devops-final-project-vpc"
  tags               = local.common_tags
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "devops-final-project-ecr"
  scan_on_push = true
  tags         = local.common_tags
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = "devops-final-project-eks"
  cluster_version     = "1.32"
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = ["t3.small"]
  node_desired_size   = 1
  node_min_size       = 1
  node_max_size       = 2
  tags                = local.common_tags
}

module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.eks_cluster_name
  namespace         = "jenkins"
  admin_secret_name = var.jenkins_admin_secret_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source                 = "./modules/argo-cd"
  namespace              = "argocd"
  chart_version          = "5.46.4"
  gitops_repo_url        = var.gitops_repo_url
  gitops_chart_path      = var.gitops_chart_path
  gitops_target_revision = var.gitops_target_revision

  rds_endpoint = module.rds.standard_endpoint
  rds_username = var.rds_username
  rds_db_name  = var.rds_db_name
  rds_password = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [module.rds]
}

module "rds" {
  source = "./modules/rds"

  name                          = "devops-final-project-db"
  use_aurora                    = var.rds_use_aurora
  engine                        = "postgres"
  engine_version                = "17.2"
  parameter_group_family_rds    = "postgres17"
  engine_cluster                = "aurora-postgresql"
  engine_version_cluster        = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  aurora_replica_count          = 1

  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.rds_db_name
  username                = var.rds_username
  password                = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  subnet_private_ids      = module.vpc.private_subnet_ids
  subnet_public_ids       = module.vpc.public_subnet_ids
  publicly_accessible     = false
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = module.vpc.vpc_cidr
  multi_az                = false
  backup_retention_period = 0

  tags = local.common_tags

  depends_on = [module.vpc]
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace              = "monitoring"
  grafana_admin_password = jsondecode(data.aws_secretsmanager_secret_version.grafana.secret_string)["password"]

  providers = {
    helm = helm
  }

  depends_on = [module.eks]
}

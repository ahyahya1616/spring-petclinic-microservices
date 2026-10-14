terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }

  # S3 backend with native state locking (supported in Terraform 1.10+)
  backend "s3" {
    bucket       = "petclinic-tfstate-240797212774"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "spring-petclinic"
      ManagedBy   = "Terraform"
    }
  }
}

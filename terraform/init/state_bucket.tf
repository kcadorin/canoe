module "terraform_state_backend" {
  source     = "cloudposse/tfstate-backend/aws"
  version    = "1.1.1"
  namespace  = "canoe"
  stage      = terraform.workspace
  name       = "core"
  attributes = ["terraform", "state"]
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

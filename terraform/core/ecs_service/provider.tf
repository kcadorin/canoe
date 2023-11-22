provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      ManagedBy  = "Terraform"
      Env        = local.env
      Layer      = "tenant/${basename(path.cwd)}"
      Repository = local.git.repo
    }
  }
}

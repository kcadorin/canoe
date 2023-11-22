provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      ManagedBy  = "Terraform"
      Env        = local.env
      Layer      = "core/${basename(path.cwd)}"
      Repository = local.git.repo
    }
  }
}

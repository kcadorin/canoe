module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  count  = local.module_vars.enabled ? 1 : 0

  repository_name = "canoe-${local.env}"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

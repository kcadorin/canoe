locals {
  aws_region  = var.aws_region
  config      = yamldecode(file("../../config/${local.env}.yaml"))
  module_vars = local.config.modules.ecs_service.vars
  env         = terraform.workspace
  git         = { "repo" : "https://github.com/kcadorin/canoe.git" }
}

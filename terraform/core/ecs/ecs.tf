module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.2.2"
  count   = local.module_vars.enabled ? 1 : 0

  cluster_name = "${local.config.core_env_name}-fargate"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}

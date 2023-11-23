module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  count   = local.module_vars.enabled ? 1 : 0

  name                    = local.config.core_env_name
  cidr                    = local.module_vars.cidr_block
  azs                     = local.config.azs.us-east-1
  public_subnets          = local.module_vars.public_subnets
  private_subnets         = local.module_vars.private_subnets
  enable_dns_hostnames    = local.module_vars.enable_dns_hostnames
  map_public_ip_on_launch = local.module_vars.map_public_ip_on_launch
  enable_nat_gateway      = local.module_vars.enable_nat_gateway
  single_nat_gateway      = local.module_vars.single_nat_gateway
  one_nat_gateway_per_az  = local.module_vars.one_nat_gateway_per_az
}

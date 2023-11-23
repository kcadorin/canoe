output "repository_arn" {
  value = module.ecr[0].repository_arn
}

output "repository_registry_id" {
  value = module.ecr[0].repository_registry_id
}

output "repository_url" {
  value = module.ecr[0].repository_url
}

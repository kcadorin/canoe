output "ecs_cluster_id" {
  value = module.ecs[0].cluster_id
}

output "ecs_cluster_name" {
  value = module.ecs[0].cluster_name
}

output "ecs_cluster_arn" {
  value = module.ecs[0].cluster_arn
}

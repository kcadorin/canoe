region               = "us-east-1"
bucket               = "canoe-development-core-terraform-state"
key                  = "terraform.tfstate"
dynamodb_table       = "canoe-development-core-terraform-state-lock"
workspace_key_prefix = "ecs_service"
encrypt              = true

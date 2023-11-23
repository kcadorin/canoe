resource "aws_secretsmanager_secret" "random_string" {
  name                    = "${local.module_vars.name}-random_string"
  description             = "Random string"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "random_string" {
  secret_id     = aws_secretsmanager_secret.random_string.id
  secret_string = random_string.random_string.result
}

resource "random_string" "random_string" {
  length  = 64
  special = false
}

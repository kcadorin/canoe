resource "aws_ecs_service" "service" {
  name                   = "${local.module_vars.name}-${local.env}"
  cluster                = local.module_vars.cluster_id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.task_definition.arn
  desired_count          = 1
  enable_execute_command = true

  network_configuration {
    security_groups  = [aws_security_group.sg_ecs.id]
    subnets          = local.config.modules.vpc.vars.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.group.id
    container_name   = local.module_vars.container_name
    container_port   = local.module_vars.container_port
  }

  depends_on = [
    aws_ecs_task_definition.task_definition
  ]

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "td_${local.module_vars.name}"
  container_definitions = <<DEFINITION
  [
          {
            "name": "${local.module_vars.container_name}",
            "image": "${local.module_vars.ecr_repository_url}:latest",
            "cpu": 0,
            "portMappings": [
                {
                    "containerPort": 3000,
                    "hostPort": 3000,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "environment": [
              {
                "name": "SERVICE_NAME",
                "value": "${local.module_vars.name}"
              }
            ],
            "secrets": [
              {
                "name": "RANDOM_STRING",
                "valueFrom": "${aws_secretsmanager_secret.random_string.arn}"
              }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.ecs.name}",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "${aws_cloudwatch_log_group.ecs.name}"
                }
            }
        }
      ]
      DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  task_role_arn            = local.module_vars.task_role_arn
  execution_role_arn       = local.module_vars.task_role_arn
}

module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${local.module_vars.name}-alb-logs"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true
}

resource "aws_alb" "alb" {
  name               = local.module_vars.name
  load_balancer_type = "application"
  subnets            = local.config.modules.vpc.vars.private_subnets
  security_groups    = [aws_security_group.sg_lb.id]

  access_logs {
    bucket  = module.s3_bucket_for_logs.s3_bucket_id
    prefix  = local.module_vars.name
    enabled = true
  }

}

resource "aws_alb_target_group" "group" {
  name                 = local.module_vars.name
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = local.module_vars.vpc_id
  deregistration_delay = 10
  slow_start           = 30

  health_check {
    matcher             = local.module_vars.health_check_matcher
    path                = local.module_vars.health_check_path
    port                = local.module_vars.container_port
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
  depends_on = [aws_alb.alb]
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = local.module_vars.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.group.arn
  }
  depends_on = [aws_alb_target_group.group]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_alb_target_group.group]
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = local.module_vars.name
  retention_in_days = 30
}

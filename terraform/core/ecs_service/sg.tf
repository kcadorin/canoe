resource "aws_security_group" "sg_lb" {
  name   = "${local.module_vars.name}-lb"
  vpc_id = local.module_vars.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_ecs" {
  name   = "${local.module_vars.name}-ecs"
  vpc_id = local.module_vars.vpc_id
  ingress {
    from_port       = local.module_vars.container_port
    to_port         = local.module_vars.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_lb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "task" {
  name               = local.config.core_env_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  inline_policy {
    name   = "aws_access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
          "s3:*"
        ]
      },
      {
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "kms:Decrypt",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "ssm:ListTagsForResource",
          "ssm:GetParameters",
          "ssm:GetParameterHistory",
          "ssm:GetParameter",
          "ssm:DescribeParameters",
          "secretsmanager:GetSecretValue",
          "cognito-identity:*",
          "cognito-idp:*",
          "cognito-sync:*",
          "iam:ListRoles",
          "iam:ListOpenIdConnectProviders",
          "iam:GetRole",
          "iam:ListSAMLProviders",
          "iam:GetSAMLProvider",
          "kinesis:ListStreams",
          "lambda:GetPolicy",
          "lambda:ListFunctions",
          "sns:GetSMSSandboxAccountStatus",
          "sns:ListPlatformApplications",
          "ses:ListIdentities",
          "ses:GetIdentityVerificationAttributes",
          "mobiletargeting:GetApps",
          "acm:ListCertificates"
        ]
      }
    ]
}
EOF
  }
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}

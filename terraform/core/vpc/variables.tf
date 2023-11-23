variable "aws_region" {
  description = "AWS Region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "region" {
  description = "AWS Region to deploy"
  type        = string
}

variable "bucket" {
  description = "Bucket for the workspace"
  type        = string
}

variable "key" {
  description = "Key for the module"
  type        = string
}

variable "dynamodb_table" {
  description = "dynamo table for the module"
  type        = string
}

variable "workspace_key_prefix" {
  description = "workspace key prefix for the module"
  type        = string
}

variable "encrypt" {
  description = "encrypt setting"
  type        = string
}

variable "aws_account_id" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "register_component_lambda_name" {
  type    = string
  default = null
}

variable "dynamo_admin_table_name" {
  type    = string
  default = null
}
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

variable "dynamo_admin_table_name" {
  type    = string
  default = null
}

variable "register_component_lambda_name" {
  type    = string
  default = null
}

variable "get_components_lambda_name" {
  type    = string
  default = null
}

variable "delete_component_lambda_name" {
  type    = string
  default = null
}

variable "idp-name" {
  type    = string
  default = null
}

variable "user-pool-client-redirect-urls" {
  type    = list(string)
}

variable "user-pool-client-logout-urls" {
  type    = list(string)
}
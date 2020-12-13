variable "aws_account_id" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "admin_lambda_name" {
  type    = string
  default = null
}

variable "get_components_lambda_name" {
  type    = string
  default = null
}
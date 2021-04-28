variable "aws_account_id" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "get_components_lambda_name" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = null
}

variable "user_pool_arn" {
  type    = string
  default = null
}

variable "domain_name" {
  type    = string
  default = null
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "create-preference-lambda-name" {
  type    = string
  default = null
}

variable "get-preference-lambda-name" {
  type    = string
  default = null
}

variable "delete-preference-lambda-name" {
  type    = string
  default = null
}
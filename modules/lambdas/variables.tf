variable "environment" {
  type    = string
  default = null
}

variable "register-component-lambda-name" {
  type    = string
  default = null
}

variable "get-components-lambda-name" {
  type    = string
  default = null
}

variable "delete-components-lambda-name" {
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

variable "aws_account_id" {
  type    = string
  default = null
}
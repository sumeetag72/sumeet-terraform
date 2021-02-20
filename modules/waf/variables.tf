variable "environment" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = "seahorse"
}

variable "whitelisted_ips" {
  description = "needed when deploy auth is disabled"
  type        = list
  default = null
}
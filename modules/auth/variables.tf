variable "environment" {
  type    = string
  default = null
}

variable "project" {
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
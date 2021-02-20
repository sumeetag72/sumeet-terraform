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

variable "domain_name" {
  type    = string
  default = null
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "deploy_auth" {
  description = "If set to true, cognito auth will be configured"
  type        = bool
  default     = false
}
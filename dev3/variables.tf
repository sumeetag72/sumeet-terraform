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

variable "app_definitions_table_name" {
  type    = string
  default = null
}

variable "user_preferences_table_name" {
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

variable "deploy_auth" {
  description = "If set to true, cognito auth will be configured"
  type        = bool
  default     = false
}

variable "user_pool_arn" {
  description = "needed when deploy auth is disabled"
  type        = string
  default = null
}

variable "whitelisted_ips" {
  description = "needed when deploy auth is disabled"
  type        = list
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

variable "hosted_zone_id" {
  type    = string
  default = null
}

variable "configure_route53" {
  description = "If set to true, route 53 mappings will be created"
  type        = bool
  default     = false
}

variable "auth_domain_name" {
  description = "cognito domaim name"
  type        = string
  default     = null
}

variable "web_api_zone_id" {
  description = "web api zone id"
  type        = string
  default     = null
}

variable "web_api_domain_name" {
  description = "web api domain name"
  type        = string
  default     = null
}

variable "admin_api_zone_id" {
  description = "admin api zone id"
  type        = string
  default     = null
}

variable "admin_api_domain_name" {
  description = "admin api domain name"
  type        = string
  default     = null
}

variable "create_preference_lambda_name" {
  description = "create user preference lambda name"
  type        = string
  default     = null
}

variable "get_preference_lambda_name" {
  description = "get user preference lambda name"
  type        = string
  default     = null
}

variable "delete_preference_lambda_name" {
  description = "delete user preference lambda name"
  type        = string
  default     = null
}

variable "admin_api_id" {
  type    = string
  default = null
}

variable "seahorse_admin_group_id" {
  type    = string
  default = null
}

variable "ssa_group_id" {
  type    = string
  default = null
}

variable "bestx_group_id" {
  type    = string
  default = null
}

variable "tradenexus_group_id" {
  type    = string
  default = null
}

variable "fxconnect_group_id" {
  type    = string
  default = null
}
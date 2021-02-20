terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

module "waf" {
  source = "../modules/waf"

  project = var.project
  environment = var.environment
  whitelisted_ips = var.whitelisted_ips
}

module "web-static" {
  source = "../modules/web-static"

  project = var.project
  environment = var.environment
  domain_name_suffix = var.domain_name_suffix
  acm_certificate_arn = var.acm_certificate_arn
  seahorse_web_acl_id = module.waf.seahorse_web_acl_id
}

module "dynamo_db" {
  source = "../modules/dynamodb"

  environment = var.environment
  table_name = var.dynamo_admin_table_name
}

module "admin_lambdas" {
  source = "../modules/lambdas"

  register-component-lambda-name = var.register_component_lambda_name
  get-components-lambda-name = var.get_components_lambda_name
  delete-components-lambda-name = var.delete_component_lambda_name
  environment = var.environment
  aws_account_id = var.aws_account_id
}

module "web-admin-api" {
  source = "../modules/web-admin-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  register_component_lambda_name = var.register_component_lambda_name
  get_components_lambda_name = var.get_components_lambda_name
  delete_component_lambda_name = var.delete_component_lambda_name
}

module "web-backend-api-with-existing-cognito" {
  count   = var.deploy_auth ? 0 : 1
  source = "../modules/web-backend-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  get_components_lambda_name = var.get_components_lambda_name
  user_pool_arn = var.user_pool_arn
}

module "auth" {
  source = "../modules/auth"
  environment = var.environment
  idp-name = var.idp-name
  user-pool-client-redirect-urls = var.user-pool-client-redirect-urls
  user-pool-client-logout-urls = var.user-pool-client-logout-urls
}

module "web-backend-api-with-fresh-cognito" {
  count   = var.deploy_auth ? 1 : 0
  source = "../modules/web-backend-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  get_components_lambda_name = var.get_components_lambda_name
  user_pool_arn = module.auth.user_pool_arn
  depends_on = [
    module.auth
  ]
}
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

module "acm" {
  source = "../modules/acm"
  environment = var.environment
}

module "waf" {
  source = "../modules/waf"

  project = var.project
  environment = var.environment
  whitelisted_ips = var.whitelisted_ips
}

module "web_static" {
  source = "../modules/web-static"

  project = var.project
  environment = var.environment
  domain_name = var.domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
  seahorse_web_acl_id = module.waf.seahorse_web_acl_id
}

module "dynamo_db" {
  source = "../modules/dynamodb"

  environment = var.environment
  app_definitions_table_name = var.app_definitions_table_name
  user_preferences_table_name = var.user_preferences_table_name
}

module "admin_lambdas" {
  source = "../modules/lambdas"

  register-component-lambda-name = var.register_component_lambda_name
  get-components-lambda-name = var.get_components_lambda_name
  delete-components-lambda-name = var.delete_component_lambda_name
  environment = var.environment
  aws_account_id = var.aws_account_id
}

# module "auth" {
#   count   = var.deploy_auth ? 0 : 1
#   source = "../modules/auth"
#   environment = var.environment
#   idp-name = var.idp-name
#   user-pool-client-redirect-urls = var.user-pool-client-redirect-urls
#   user-pool-client-logout-urls = var.user-pool-client-logout-urls
#   deploy_auth   = var.deploy_auth
#   domain_name = var.domain_name
#   acm_certificate_arn = module.acm.acm_certificate_arn
# }

module "web_admin_api" {
  source = "../modules/web-admin-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  register_component_lambda_name = var.register_component_lambda_name
  get_components_lambda_name = var.get_components_lambda_name
  delete_component_lambda_name = var.delete_component_lambda_name
  domain_name = var.domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
  depends_on = [
    module.admin_lambdas, module.auth
  ]
}

module "web_backend_api_with_existing_cognito" {
  count   = var.deploy_auth ? 0 : 1
  source = "../modules/web-backend-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  get_components_lambda_name = var.get_components_lambda_name
  user_pool_arn = var.user_pool_arn
  domain_name = var.domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
  depends_on = [
    module.admin_lambdas, module.auth
  ]
}

module "web_backend_api_with_fresh_auth_setup" {

  source = "../modules/web-backend-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  get_components_lambda_name = var.get_components_lambda_name
  user_pool_arn = module.auth.user_pool_arn
  domain_name = var.domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
  depends_on = [
    module.admin_lambdas, module.auth
  ]
}

module "route53_setup" {
  source = "../modules/route53"
  region = var.region
  hosted_zone_id = var.hosted_zone_id
  domain_name = var.domain_name
  finsemble_cdn_domain_name = module.web_static.finsemble_cdn_domain_name
  storybook_cdn_domain_name = module.web_static.storybook_cdn_domain_name
  docusaurus_cdn_domain_name = module.web_static.docusaurus_cdn_domain_name
  example_cdn_domain_name = module.web_static.example_cdn_domain_name
  web_api_zone_id = module.web_backend_api_with_fresh_auth_setup.zone_id
  web_api_cdn_domain_name = module.web_backend_api_with_fresh_auth_setup.domain_name
  admin_api_zone_id = module.web_admin_api.zone_id
  admin_api_cdn_domain_name = module.web_admin_api.domain_name
  cognito_cdn_domain_name = module.auth.domain_name[0]
  depends_on = [
    module.auth, module.web_admin_api, module.admin_lambdas, module.web_static
  ]
}
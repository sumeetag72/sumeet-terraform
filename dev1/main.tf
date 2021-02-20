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

module "s3_buckets" {
  source = "../modules/s3-buckets"

  project = var.project
  environment = var.environment

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

module "admin-api" {
  source = "../modules/admin-api"
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
  source = "./modules/auth"
  environment = var.environment
  idp-name = var.idp-name
  user-pool-client-redirect-urls = var.user-pool-client-redirect-urls
  user-pool-client-logout-urls = var.user-pool-client-logout-urls
}

module "web-backend-api-with-fresh-cognito" {
  count   = var.deploy_auth ? 1 : 0
  source = "./modules/web-backend-api"
  aws_account_id = var.aws_account_id
  region = var.region
  environment = var.environment
  get_components_lambda_name = var.get_components_lambda_name
  user_pool_arn = module.auth.user_pool_arn
  depends_on = [
    module.auth
  ]
}
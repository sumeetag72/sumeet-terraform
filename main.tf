terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
}

provider "aws" {
  profile = "276164198880_GL-ReleaseEngg"
  region  = var.region
}

module "s3_buckets" {
  source = "./modules/s3-buckets"

  project = var.project
  environment = var.environment

}

module "dynamo_db" {
  source = "./modules/dynamodb"

    environment = var.environment
}

module "admin_lambdas" {
  source = "./modules/lambdas"

  register-component-lambda-name = var.register-component-lambda-name
  environment = var.environment

}

resource "aws_api_gateway_rest_api" "admin_api" {
  name = "seahorse-admin-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "admin_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  parent_id = aws_api_gateway_rest_api.admin_api.root_resource_id
  path_part = "fsbl"
}

resource "aws_api_gateway_method" "admin_api_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "admin_api_method-integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_method.http_method
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${module.admin_lambdas.admin_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "admin_api_deployment_dev" {
  depends_on = [
    aws_api_gateway_method.admin_api_method,
    aws_api_gateway_integration.admin_api_method-integration
  ]
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  stage_name = "dev"
}

resource "aws_lambda_permission" "admin-api-gw-root" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = "${module.admin_lambdas.admin_lambda_name}"
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
}

output "dev_url" {
  value = "https://${aws_api_gateway_deployment.admin_api_deployment_dev.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.admin_api_deployment_dev.stage_name}"
}
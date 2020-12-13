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

################################### REGISTER COMPONENT ######################################## 

resource "aws_api_gateway_method" "admin_api_register_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "POST"
  authorization = "NONE"
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration" "admin_api_register_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.admin_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "admin_api_register_method_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "admin_api_register_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  status_code = aws_api_gateway_method_response.admin_api_register_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.admin_api_register_method_integration
  ]
}
############################################### GET COMPONENTS ##############################################

resource "aws_api_gateway_method" "admin_api_get_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration" "admin_api_get_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.get_components_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "admin_api_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "admin_api_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  status_code = aws_api_gateway_method_response.admin_api_get_method_response.status_code

  depends_on = [
    aws_api_gateway_integration.admin_api_get_method_integration
  ]
}

resource "aws_api_gateway_deployment" "admin_api_deployment_dev" {
  depends_on = [
    aws_api_gateway_method.admin_api_register_method,
    aws_api_gateway_integration.admin_api_register_method_integration,
    aws_api_gateway_method_response.admin_api_register_method_response,
    aws_api_gateway_integration_response.admin_api_register_integration_response,
    aws_api_gateway_method.admin_api_get_method,
    aws_api_gateway_integration.admin_api_get_method_integration,
    aws_api_gateway_method_response.admin_api_get_method_response,
    aws_api_gateway_integration_response.admin_api_get_integration_response
  ]
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  stage_name = "dev"
}

resource "aws_lambda_permission" "admin-register-lambda-permission" {
  statement_id = "AllowAPIGatewayInvokePost"
  action = "lambda:InvokeFunction"
  function_name = var.admin_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "admin-get-lambda-permission" {
  statement_id = "AllowAPIGatewayInvokeGet"
  action = "lambda:InvokeFunction"
  function_name = var.get_components_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
}

output "dev_url" {
  value = "https://${aws_api_gateway_deployment.admin_api_deployment_dev.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.admin_api_deployment_dev.stage_name}"
}
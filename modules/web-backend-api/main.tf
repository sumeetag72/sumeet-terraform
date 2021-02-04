resource "aws_api_gateway_rest_api" "web_backend_api" {
  name = "seahorse-web-backend-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "web_backend_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_rest_api.web_backend_api.root_resource_id
  path_part = "{proxy+}"
}

resource "aws_api_gateway_authorizer" "web_authorizer" {
name          = "Seahorse-Authorizer"
type          = "COGNITO_USER_POOLS"
rest_api_id   = aws_api_gateway_rest_api.web_backend_api.id
provider_arns = [var.user_pool_arn]
}

############################################### GET COMPONENTS ##############################################

resource "aws_api_gateway_method" "web_backend_api_get_method" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.web_authorizer.id
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "web_backend_api_get_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.web_backend_api_get_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.get_components_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "web_backend_api_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.web_backend_api_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "web_backend_api_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.web_backend_api_get_method.http_method
  status_code = aws_api_gateway_method_response.web_backend_api_get_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.web_backend_api_get_method_integration
  ]
}

###############################################CORS##################################################

resource "aws_api_gateway_method" "mock_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.web_backend_api.id
  resource_id   = aws_api_gateway_resource.web_backend_api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mock_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.mock_options_method.http_method
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "mock_options_response" {
  depends_on = [aws_api_gateway_method.mock_options_method]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.mock_options_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "mock_options_integration_response" {
  depends_on = [aws_api_gateway_integration.mock_options_integration, aws_api_gateway_method_response.mock_options_response]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.web_backend_api_resource.id
  http_method = aws_api_gateway_method.mock_options_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # replace with hostname of frontend (CloudFront)
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, POST'" # remove or add HTTP methods as needed
  }
}

############################################### DEPLOY ##############################################

resource "aws_api_gateway_deployment" "web_backend_api_deployment" {
  depends_on = [
    aws_api_gateway_method.web_backend_api_get_method,
    aws_api_gateway_integration.web_backend_api_get_method_integration,
    aws_api_gateway_method_response.web_backend_api_get_method_response,
    aws_api_gateway_integration_response.web_backend_api_get_integration_response,
    aws_api_gateway_method.mock_options_method,
    aws_api_gateway_integration.mock_options_integration,
    aws_api_gateway_method_response.mock_options_response,
    aws_api_gateway_integration_response.mock_options_integration_response
  ]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  stage_name = var.environment
}

resource "aws_lambda_permission" "get-lambda-permission" {
  statement_id = "AllowWebBackendAPIGatewayInvokeGet"
  action = "lambda:InvokeFunction"
  function_name = var.get_components_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_backend_api.execution_arn}/*/*/*"
}

output "dev_url" {
  value = "https://${aws_api_gateway_deployment.web_backend_api_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.web_backend_api_deployment.stage_name}"
}
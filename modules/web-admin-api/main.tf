resource "aws_api_gateway_rest_api" "admin_api" {
  name = "seahorse-admin-api"
}

resource "aws_api_gateway_resource" "admin_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  parent_id = aws_api_gateway_rest_api.admin_api.root_resource_id
  path_part = "{proxy+}"
}

resource "aws_api_gateway_rest_api_policy" "admin_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  policy = templatefile("${path.module}/policy/admin-api-policy.tpl", {
    api_execution_arn = aws_api_gateway_rest_api.admin_api.execution_arn
  })
}

################################### REGISTER COMPONENT ######################################## 

resource "aws_api_gateway_method" "admin_api_register_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "POST"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "admin_api_register_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.register_component_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "admin_api_register_method_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "admin_api_register_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_register_method.http_method
  status_code = aws_api_gateway_method_response.admin_api_register_method_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # will be cloudfront host when available
  }
  depends_on = [
    aws_api_gateway_integration.admin_api_register_method_integration
  ]
}
############################################### GET COMPONENTS ##############################################

resource "aws_api_gateway_method" "admin_api_get_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "GET"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "admin_api_get_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.get_components_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "admin_api_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "admin_api_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_get_method.http_method
  status_code = aws_api_gateway_method_response.admin_api_get_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.admin_api_get_method_integration
  ]
}

#####################################DELETE COMPONENT#####################################################

resource "aws_api_gateway_method" "admin_api_delete_method" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = "DELETE"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "admin_api_delete_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_delete_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.delete_component_lambda_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "admin_api_delete_method_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_delete_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "admin_api_delete_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.admin_api_delete_method.http_method
  status_code = aws_api_gateway_method_response.admin_api_delete_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.admin_api_delete_method_integration
  ]
}

###############################################CORS##################################################

resource "aws_api_gateway_method" "mock_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.admin_api.id
  resource_id   = aws_api_gateway_resource.admin_api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mock_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.mock_options_method.http_method
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "mock_options_response" {
  depends_on = [aws_api_gateway_method.mock_options_method]
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
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
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_api_resource.id
  http_method = aws_api_gateway_method.mock_options_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # replace with hostname of frontend (CloudFront)
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, POST'" # remove or add HTTP methods as needed
  }
}

############################################### DEPLOY ##############################################

resource "aws_api_gateway_deployment" "admin_api_deployment" {
  depends_on = [
    aws_api_gateway_method.admin_api_register_method,
    aws_api_gateway_integration.admin_api_register_method_integration,
    aws_api_gateway_method_response.admin_api_register_method_response,
    aws_api_gateway_integration_response.admin_api_register_integration_response,
    aws_api_gateway_method.admin_api_get_method,
    aws_api_gateway_integration.admin_api_get_method_integration,
    aws_api_gateway_method_response.admin_api_get_method_response,
    aws_api_gateway_integration_response.admin_api_get_integration_response,
    aws_api_gateway_method.mock_options_method,
    aws_api_gateway_integration.mock_options_integration,
    aws_api_gateway_method_response.mock_options_response,
    aws_api_gateway_integration_response.mock_options_integration_response
  ]
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  stage_name = var.environment
}

resource "aws_lambda_permission" "admin-register-lambda-permission" {
  statement_id = "AllowAPIGatewayInvokePost"
  action = "lambda:InvokeFunction"
  function_name = var.register_component_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
  depends_on = [
    aws_api_gateway_deployment.admin_api_deployment
  ]
}

resource "aws_lambda_permission" "admin-get-lambda-permission" {
  statement_id = "AllowAPIGatewayInvokeGet"
  action = "lambda:InvokeFunction"
  function_name = var.get_components_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
  depends_on = [
    aws_api_gateway_deployment.admin_api_deployment
  ]
}

resource "aws_lambda_permission" "admin-delete-lambda-permission" {
  statement_id = "AllowAPIGatewayInvokeGet"
  action = "lambda:InvokeFunction"
  function_name = var.delete_component_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*/*"
  depends_on = [
    aws_api_gateway_deployment.admin_api_deployment
  ]
}

############################ ATTACH DOMAIN ####################################

resource "aws_api_gateway_domain_name" "admin_api_domain_name" {
  domain_name = format("%s.%s", "adminapi", var.domain_name)
  certificate_arn = var.acm_certificate_arn
  depends_on = [
    aws_api_gateway_deployment.admin_api_deployment
  ]
}

resource "aws_api_gateway_base_path_mapping" "admin_api_path_mapping" {
  api_id      = aws_api_gateway_rest_api.admin_api.id
  stage_name  = aws_api_gateway_deployment.admin_api_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.admin_api_domain_name.domain_name
  depends_on = [
    aws_api_gateway_domain_name.admin_api_domain_name
  ]
}

output "admin_api_url" {
  value = "https://${aws_api_gateway_deployment.admin_api_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.admin_api_deployment.stage_name}"
}
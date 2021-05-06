resource "aws_api_gateway_rest_api" "web_backend_api" {
  name = "seahorse-web-backend-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "web_authorizer" {
name          = "Seahorse-Authorizer"
type          = "COGNITO_USER_POOLS"
rest_api_id   = aws_api_gateway_rest_api.web_backend_api.id
provider_arns = [var.user_pool_arn]
}

############################################### COMPONENTS API ######################################

resource "aws_api_gateway_resource" "web_backend_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_rest_api.web_backend_api.root_resource_id
  path_part = "{proxy+}"
}



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


#######################################################################################
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
  request_templates = {               
    "application/json" = file("${path.module}/templates/mapping-template.json")
  }
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


############################################### PREFERENCES API GET ALL ######################################

resource "aws_api_gateway_resource" "preferences_storage_path_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_rest_api.web_backend_api.root_resource_id
  path_part = "storage"
}

resource "aws_api_gateway_resource" "preferences_api_path_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_resource.preferences_storage_path_resource.id
  path_part = "api"
}

resource "aws_api_gateway_resource" "preferences_api_app_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_resource.preferences_api_path_resource.id
  path_part = "app"
}

resource "aws_api_gateway_resource" "preferences_api_userid_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_resource.preferences_api_app_resource.id
  path_part = "{userId}"
}

resource "aws_api_gateway_resource" "preferences_api_get_all_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_resource.preferences_api_userid_resource.id
  path_part = "{app}"
}


resource "aws_api_gateway_method" "preferences_api_get_all_method" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
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

resource "aws_api_gateway_integration" "preferences_api_get_all_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_all_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.get-preference-lambda-name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "preferences_api_get_all_method_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_all_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "preferences_get_all_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_all_method.http_method
  status_code = aws_api_gateway_method_response.preferences_api_get_all_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.preferences_api_get_all_method_integration
  ]
}

resource "aws_api_gateway_method" "get_all_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.web_backend_api.id
  resource_id   = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_all_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.get_all_options_method.http_method
  type = "MOCK"
  request_templates = {               
    "application/json" = file("${path.module}/templates/mapping-template.json")
  }
}

resource "aws_api_gateway_method_response" "get_all_options_response" {
  depends_on = [aws_api_gateway_method.get_all_options_method]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.get_all_options_method.http_method
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

resource "aws_api_gateway_integration_response" "get_all_options_integration_response" {
  depends_on = [aws_api_gateway_integration.get_all_options_integration, aws_api_gateway_method_response.get_all_options_response]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  http_method = aws_api_gateway_method.get_all_options_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # replace with hostname of frontend (CloudFront)
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, POST'" # remove or add HTTP methods as needed
  }
}

############################################### PREFERENCES API ######################################

resource "aws_api_gateway_resource" "preferences_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  parent_id = aws_api_gateway_resource.preferences_api_get_all_resource.id
  path_part = "{preferenceId}"
}


resource "aws_api_gateway_method" "preferences_api_get_method" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
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

resource "aws_api_gateway_integration" "preferences_api_get_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.get-preference-lambda-name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "preferences_api_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "preferences_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_get_method.http_method
  status_code = aws_api_gateway_method_response.preferences_api_get_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.preferences_api_get_method_integration
  ]
}

resource "aws_api_gateway_method" "preferences_api_create_method" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.web_authorizer.id
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "preferences_api_create_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_create_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.create-preference-lambda-name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "preferences_api_create_method_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_create_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "preferences_api_create_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_create_method.http_method
  status_code = aws_api_gateway_method_response.preferences_api_create_method_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # will be cloudfront host when available
  }
  depends_on = [
    aws_api_gateway_integration.preferences_api_create_method_integration
  ]
}

resource "aws_api_gateway_method" "preferences_api_delete_method" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.web_authorizer.id
  request_parameters = {
    "method.request.header.Content-Type" = true
  }
  request_models = { 
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration" "preferences_api_delete_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_delete_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.aws_account_id}:function:${var.delete-preference-lambda-name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "preferences_api_delete_method_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_delete_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "preferences_api_delete_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.preferences_api_delete_method.http_method
  status_code = aws_api_gateway_method_response.preferences_api_delete_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", # r# will be cloudfront host when available
  }

  depends_on = [
    aws_api_gateway_integration.preferences_api_delete_method_integration
  ]
}

resource "aws_api_gateway_method" "get_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.web_backend_api.id
  resource_id   = aws_api_gateway_resource.preferences_api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.get_options_method.http_method
  type = "MOCK"
  request_templates = {               
    "application/json" = file("${path.module}/templates/mapping-template.json")
  }
}

resource "aws_api_gateway_method_response" "get_options_response" {
  depends_on = [aws_api_gateway_method.get_options_method]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.get_options_method.http_method
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

resource "aws_api_gateway_integration_response" "get_options_integration_response" {
  depends_on = [aws_api_gateway_integration.get_options_integration, aws_api_gateway_method_response.get_options_response]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  resource_id = aws_api_gateway_resource.preferences_api_resource.id
  http_method = aws_api_gateway_method.get_options_method.http_method
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
    aws_api_gateway_authorizer.web_authorizer,
    aws_api_gateway_resource.web_backend_api_resource,
    aws_api_gateway_resource.preferences_api_get_all_resource,
    aws_api_gateway_resource.preferences_api_resource,
    aws_api_gateway_method.web_backend_api_get_method,
    aws_api_gateway_integration.web_backend_api_get_method_integration,
    aws_api_gateway_method_response.web_backend_api_get_method_response,
    aws_api_gateway_integration_response.web_backend_api_get_integration_response,
    aws_api_gateway_method.mock_options_method,
    aws_api_gateway_integration.mock_options_integration,
    aws_api_gateway_method_response.mock_options_response,
    aws_api_gateway_integration_response.mock_options_integration_response,
    aws_api_gateway_method.preferences_api_get_method,
    aws_api_gateway_integration.preferences_api_get_method_integration,
    aws_api_gateway_method_response.preferences_api_get_method_response,
    aws_api_gateway_integration_response.preferences_get_integration_response,
    aws_api_gateway_method.preferences_api_create_method,
    aws_api_gateway_integration.preferences_api_create_method_integration,
    aws_api_gateway_method_response.preferences_api_create_method_response,
    aws_api_gateway_integration_response.preferences_api_create_integration_response,
    aws_api_gateway_method.preferences_api_delete_method,
    aws_api_gateway_integration.preferences_api_delete_method_integration,
    aws_api_gateway_method_response.preferences_api_delete_method_response,
    aws_api_gateway_integration_response.preferences_api_delete_integration_response,
    aws_api_gateway_method.preferences_api_get_all_method,
    aws_api_gateway_integration.preferences_api_get_all_method_integration,
    aws_api_gateway_method_response.preferences_api_get_all_method_response,
    aws_api_gateway_integration_response.preferences_get_all_integration_response,
    aws_api_gateway_method.get_all_options_method,
    aws_api_gateway_integration.get_all_options_integration,
    aws_api_gateway_method_response.get_all_options_response,
    aws_api_gateway_integration_response.get_all_options_integration_response,
  ]
  rest_api_id = aws_api_gateway_rest_api.web_backend_api.id
  stage_name = var.environment
}

############################ LAMBDA PERMISSIONS ####################################

resource "aws_lambda_permission" "get-lambda-permission" {
  statement_id = "AllowGetComponent"
  action = "lambda:InvokeFunction"
  function_name = var.get_components_lambda_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_backend_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "create-preference-lambda-permission" {
  statement_id = "AllowCreatePreference"
  action = "lambda:InvokeFunction"
  function_name = var.create-preference-lambda-name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_backend_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "get-preference-lambda-permission" {
  statement_id = "AllowGetPreference"
  action = "lambda:InvokeFunction"
  function_name = var.get-preference-lambda-name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_backend_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "delete-preference-lambda-permission" {
  statement_id = "AllowDeletePreference"
  action = "lambda:InvokeFunction"
  function_name = var.delete-preference-lambda-name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.web_backend_api.execution_arn}/*/*/*"
}

############################ ATTACH DOMAIN ####################################

resource "aws_api_gateway_domain_name" "web_api_domain_name" {
  domain_name = format("%s.%s", "webapi", var.domain_name)
  certificate_arn = var.acm_certificate_arn
  depends_on = [
    aws_api_gateway_deployment.web_backend_api_deployment
  ]
}

resource "aws_api_gateway_base_path_mapping" "web_api_path_mapping" {
  api_id      = aws_api_gateway_rest_api.web_backend_api.id
  stage_name  = aws_api_gateway_deployment.web_backend_api_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.web_api_domain_name.domain_name
  depends_on = [
    aws_api_gateway_domain_name.web_api_domain_name
  ]
}

output "web_api_url" {
  value = "https://${aws_api_gateway_deployment.web_backend_api_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.web_backend_api_deployment.stage_name}"
}
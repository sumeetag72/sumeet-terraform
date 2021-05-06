resource "aws_iam_role" "seahorse_iam_role_for_lambdas" {
  name               = "seahorse_iam_role_for_lambdas"
  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
}
EOF
}

resource "aws_iam_policy" "create_definition_lambdas_exec_policy" {
  name = "seahorse_admin_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.register-component-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "get_definition_lambda_exec_policy" {
  name = "get_definition_lambda_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.get-components-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "delete_definition_lambdas_exec_policy" {
  name = "delete_definition_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.delete-components-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "create_preference_lambdas_exec_policy" {
  name = "create_preference_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.create-preference-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "get_preference_lambda_exec_policy" {
  name = "get_preference_lambda_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.get-preference-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "delete_preference_lambdas_exec_policy" {
  name = "delete_preference_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/lambda-policy.tpl", {
    lambda_name = var.delete-preference-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "register_definition_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.create_definition_lambdas_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "get_definition_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.get_definition_lambda_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_definition_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.delete_definition_lambdas_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "create_preference_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.create_preference_lambdas_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "get_preference_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.get_preference_lambda_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_preference_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.delete_preference_lambdas_exec_policy.arn
}

resource "aws_lambda_function" "RegisterComponentLambda" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.register-component-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.components.RegisterComponentService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "GetRegisteredComponents" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.get-components-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.components.GetComponentService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "DeleteRegisteredComponent" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.delete-components-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.components.DeleteComponentService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "CreatePreferenceLambda" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.create-preference-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.preference.CreateUserPreferenceService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "GetPreferenceLambda" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.get-preference-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.preference.GetUserPreferenceService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "DeletePreferenceLambda" {
  filename      = "../../seahorse/server/app.services/target/seahorse-services-1.0.jar"
  function_name = var.delete-preference-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.services.preference.DeleteUserPreferenceService::handleRequest"

  runtime = "java8"
  memory_size = "4096"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_cloudwatch_event_rule" "app_definition_ping" {
  name                = "app_definition_ping"
  description         = "Pings app definition lambdas every one minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "ping_register_lambda" {
  rule      = aws_cloudwatch_event_rule.app_definition_ping.name
  target_id = "register-ping"
  arn       = aws_lambda_function.RegisterComponentLambda.arn
}

resource "aws_cloudwatch_event_target" "ping_get_lambda" {
  rule      = aws_cloudwatch_event_rule.app_definition_ping.name
  target_id = "get-ping"
  arn       = aws_lambda_function.GetRegisteredComponents.arn
}

resource "aws_cloudwatch_event_target" "ping_delete_lambda" {
  rule      = aws_cloudwatch_event_rule.app_definition_ping.name
  target_id = "delete-ping"
  arn       = aws_lambda_function.DeleteRegisteredComponent.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_register_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.RegisterComponentLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.app_definition_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_get_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.GetRegisteredComponents.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.app_definition_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_delete_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.DeleteRegisteredComponent.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.app_definition_ping.arn
}

resource "aws_cloudwatch_event_rule" "user_preference_ping" {
  name                = "user_preference_ping"
  description         = "Pings user preference lambdas every one minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "ping_create_preference_lambda" {
  rule      = aws_cloudwatch_event_rule.user_preference_ping.name
  target_id = "create-preference-ping"
  arn       = aws_lambda_function.CreatePreferenceLambda.arn
}

resource "aws_cloudwatch_event_target" "ping_get_preference" {
  rule      = aws_cloudwatch_event_rule.user_preference_ping.name
  target_id = "get-preference"
  arn       = aws_lambda_function.GetPreferenceLambda.arn
}

resource "aws_cloudwatch_event_target" "ping_delete_preference" {
  rule      = aws_cloudwatch_event_rule.user_preference_ping.name
  target_id = "delete-preference"
  arn       = aws_lambda_function.DeletePreferenceLambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_preference_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CreatePreferenceLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.user_preference_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_get_preference_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.GetPreferenceLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.user_preference_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_delete_preference_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.DeletePreferenceLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.user_preference_ping.arn
}
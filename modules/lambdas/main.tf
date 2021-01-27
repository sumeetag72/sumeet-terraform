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

resource "aws_iam_policy" "seahorse_admin_lambdas_exec_policy" {
  name = "seahorse_admin_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/admin-lambda-policy.tpl", {
    register_component_lambda_name = var.register-component-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "seahorse_get_lambdas_exec_policy" {
  name = "seahorse_get_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/admin-lambda-policy.tpl", {
    register_component_lambda_name = var.get-components-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_policy" "seahorse_delete_lambdas_exec_policy" {
  name = "seahorse_delete_lambdas_exec_policy"
  policy = templatefile("${path.module}/policy/admin-lambda-policy.tpl", {
    register_component_lambda_name = var.delete-components-lambda-name
    aws_account_id = var.aws_account_id
  })
}

resource "aws_iam_role_policy_attachment" "admin_lambda_dynamodb" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "admin_register_lambda_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.seahorse_admin_lambdas_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "admin_get_lambda_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.seahorse_get_lambdas_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "admin_delete_lambda_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_lambdas.name
  policy_arn = aws_iam_policy.seahorse_delete_lambdas_exec_policy.arn
}

resource "aws_lambda_function" "RegisterComponentLambda" {
  filename      = "../seahorse-server/app.adminservices/target/adminservices-1.0.jar"
  function_name = var.register-component-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.admin.fsbl.RegisterComponentService::handleRequest"

  runtime = "java8"
  memory_size = "512"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "GetRegisteredComponents" {
  filename      = "../seahorse-server/app.adminservices/target/adminservices-1.0.jar"
  function_name = var.get-components-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.admin.fsbl.GetComponentService::handleRequest"

  runtime = "java8"
  memory_size = "512"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_lambda_function" "DeleteRegisteredComponent" {
  filename      = "../seahorse-server/app.adminservices/target/adminservices-1.0.jar"
  function_name = var.delete-components-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_lambdas.arn
  handler       = "com.globallink.admin.fsbl.DeleteComponentService::handleRequest"

  runtime = "java8"
  memory_size = "512"
  timeout = "15"

  publish = true

  environment {
    variables = {
      environment = var.environment
    }
  }
}

resource "aws_cloudwatch_event_rule" "one_minute_ping" {
  name                = "one_minute_ping"
  description         = "Pings every one minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "ping_register_lambda_every_one_minute" {
  rule      = aws_cloudwatch_event_rule.one_minute_ping.name
  target_id = "register-ping"
  arn       = aws_lambda_function.RegisterComponentLambda.arn
}

resource "aws_cloudwatch_event_target" "ping_get_lambda_every_one_minute" {
  rule      = aws_cloudwatch_event_rule.one_minute_ping.name
  target_id = "get-ping"
  arn       = aws_lambda_function.GetRegisteredComponents.arn
}

resource "aws_cloudwatch_event_target" "ping_delete_lambda_every_one_minute" {
  rule      = aws_cloudwatch_event_rule.one_minute_ping.name
  target_id = "get-ping"
  arn       = aws_lambda_function.DeleteRegisteredComponent.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_register_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.RegisterComponentLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.one_minute_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_get_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.GetRegisteredComponents.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.one_minute_ping.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_ping_delete_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.DeleteRegisteredComponent.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.one_minute_ping.arn
}
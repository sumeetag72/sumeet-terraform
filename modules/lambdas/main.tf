resource "aws_iam_role" "seahorse_iam_role_for_admin_lambdas" {
  name               = "seahorse_iam_role_for_admin_lambdas"
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
  })
}

resource "aws_iam_role_policy_attachment" "admin_lambda_dynamodb" {
  role       = aws_iam_role.seahorse_iam_role_for_admin_lambdas.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "admin_lambda_exec" {
  role       = aws_iam_role.seahorse_iam_role_for_admin_lambdas.name
  policy_arn = aws_iam_policy.seahorse_admin_lambdas_exec_policy.arn
}

resource "aws_lambda_function" "RegisterComponentLambda" {
  filename      = "../seahorse-server/app.adminservices/target/adminservices-1.0.jar"
  function_name = var.register-component-lambda-name
  role          = aws_iam_role.seahorse_iam_role_for_admin_lambdas.arn
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
  role          = aws_iam_role.seahorse_iam_role_for_admin_lambdas.arn
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
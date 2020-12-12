output "admin_lambda_name" {
  description = "ARN of the lambda"
  value       = aws_lambda_function.RegisterComponentLambda.function_name
}
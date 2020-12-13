output "admin_lambda_name" {
  description = "ARN of the lambda"
  value       = aws_lambda_function.RegisterComponentLambda.function_name
}

output "get_components_lambda_name" {
  value       = aws_lambda_function.GetRegisteredComponents.function_name
}
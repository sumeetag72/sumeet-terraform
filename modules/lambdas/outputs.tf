output "admin_lambda_name" {
  description = "ARN of the registration lambda"
  value       = aws_lambda_function.RegisterComponentLambda.function_name
}

output "get_components_lambda_name" {
  description = "ARN of the read registration lambda"
  value       = aws_lambda_function.GetRegisteredComponents.function_name
}

output "delete_component_lambda_name" {
  description = "ARN of the delete application registration lambda"
  value       = aws_lambda_function.DeleteRegisteredComponent.function_name
}

output "create_preference_lambda_name" {
  description = "ARN of the create preference lambda"
  value       = aws_lambda_function.CreatePreferenceLambda.function_name
}

output "get_preference_lambda_name" {
  description = "ARN of the get preference lambda"
  value       = aws_lambda_function.GetPreferenceLambda.function_name
}

output "delete_preference_lambda_name" {
  description = "ARN of the delete preference lambda"
  value       = aws_lambda_function.DeletePreferenceLambda.function_name
}
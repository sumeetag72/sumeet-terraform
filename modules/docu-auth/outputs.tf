output "domain_name" {
  description = "default cloud front domain name for cognito app"
  value       = aws_cognito_user_pool_domain.domain[*].cloudfront_distribution_arn
}
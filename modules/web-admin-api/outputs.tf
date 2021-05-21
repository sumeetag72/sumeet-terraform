output "admin_api_id" {
  description = "api id for admin api"
  value       = aws_api_gateway_rest_api.admin_api.id
}

output "domain_name" {
  description = "default cloud front domain name for admin backend api"
  value       = aws_api_gateway_domain_name.admin_api_domain_name.cloudfront_domain_name
}

output "zone_id" {
  description = "hosted zone id for web backend api"
  value       = aws_api_gateway_domain_name.admin_api_domain_name.cloudfront_zone_id
}
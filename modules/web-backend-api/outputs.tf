output "domain_name" {
  description = "default cloud front domain name for web backend api"
  value       = aws_api_gateway_domain_name.web_api_domain_name.cloudfront_domain_name
}

output "zone_id" {
  description = "hosted zone id for web backend api"
  value       = aws_api_gateway_domain_name.web_api_domain_name.cloudfront_zone_id
}
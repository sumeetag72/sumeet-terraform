output "finsemble_bucket_name" {
  description = "Bucket name where Finsemble is deployed"
  value       = aws_s3_bucket.finsemble.bucket
}

output "finsemble_cdn_domain_name" {
  description = "default cloud front domain name for finsemble"
  value       = aws_cloudfront_distribution.finsemble_distribution.domain_name
}

output "storybook_cdn_domain_name" {
  description = "default cloud front domain name for storybook"
  value       = aws_cloudfront_distribution.storybook_distribution.domain_name
}

output "docusaurus_cdn_domain_name" {
  description = "default cloud front domain name for docusaurus"
  value       = aws_cloudfront_distribution.docs_distribution.domain_name
}

output "example_cdn_domain_name" {
  description = "default cloud front domain name for example app"
  value       = aws_cloudfront_distribution.example_distribution.domain_name
}
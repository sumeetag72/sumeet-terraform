output "acm_certificate_arn" {
  description = "ARN of the imported certificate"
  value       = aws_acm_certificate.web_cert.arn
}
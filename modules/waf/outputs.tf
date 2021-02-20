output "seahorse_web_acl_id" {
  description = "Seahorse web acl id"
  value       = aws_waf_web_acl.waf_acl.id
}
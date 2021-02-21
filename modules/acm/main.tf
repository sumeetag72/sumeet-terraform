resource "aws_acm_certificate" "web_cert" {
  private_key=file("${path.module}/../../${var.environment}/certs/private.key")
  certificate_body = file("${path.module}/../../${var.environment}/certs/main.crt")
  certificate_chain=file("${path.module}/../../${var.environment}/certs/ca.crt")
}
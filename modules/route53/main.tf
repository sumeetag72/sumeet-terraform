locals {
  docusaurus_domain = format("docusaurus.%s", var.finsemble_cdn_domain_name)
  storybook_domain  = format("storybook.%s", var.domain_name)
  finsemble_domain  = format("web.%s", var.domain_name)
  example_app_domain= format("simple-app.%s", var.domain_name)
  web_api_domain    = format("webapi.%s", var.domain_name)
  admin_api_domain  = format("adminapi.%s", var.domain_name)
  auth_domain       = format("auth.%s", var.domain_name)
}

resource "aws_route53_record" "finsemble" {
  zone_id = var.hosted_zone_id
  name = local.finsemble_domain
  type = "A"

  alias {
    name = var.finsemble_cdn_domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "storybook" {
  zone_id = var.hosted_zone_id
  name = local.storybook_domain
  type = "A"

  alias {
    name = var.storybook_cdn_domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "docusaurus" {
  zone_id = var.hosted_zone_id
  name = local.docusaurus_domain
  type = "A"

  alias {
    name = var.docusaurus_cdn_domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "example-app" {
  zone_id = var.hosted_zone_id
  name = local.example_app_domain
  type = "A"

  alias {
    name = var.example_cdn_domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin-api" {
  zone_id = var.hosted_zone_id
  name = local.admin_api_domain
  type = "A"

  alias {
    name = var.admin_api_cdn_domain_name
    zone_id = var.admin_api_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "web-api" {
  zone_id = var.hosted_zone_id
  name = local.web_api_domain
  type = "A"

  alias {
    name = var.web_api_cdn_domain_name
    zone_id =  var.web_api_zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "auth" {
#   zone_id = var.hosted_zone_id
#   name = local.auth_domain
#   type = "A"

#   alias {
#     name = var.cognito_cdn_domain_name
#     zone_id = "Z2FDTNDATAQYW2"
#     evaluate_target_health = true
#   }
# }
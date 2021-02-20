locals {
  ipset_name = format("%s.%s.ipset", var.environment, var.project)
  cf_waf_rule = "IPMatchRule"
  cf_waf_acl = "AllowSourceIPs"
}

resource "aws_waf_ipset" "ipset" {
    name = local.ipset_name
    dynamic "ip_set_descriptors" {
    # The for_each argument is a hardcoded list in this illustrative example,
    # however it can be sourced from a variable or local value as well as
    # support multiple argument values as a map.
    for_each = var.whitelisted_ips

    content {
      type  = "IPV4"
      value = ip_set_descriptors.value
    }
  }
}

resource "aws_waf_rule" "wafrule" {
    depends_on  = [aws_waf_ipset.ipset]

    name        = local.cf_waf_rule
    metric_name = local.cf_waf_rule

    predicates {
        data_id = aws_waf_ipset.ipset.id
        negated = false
        type    = "IPMatch"
    }
}

resource "aws_waf_web_acl" "waf_acl" {
    depends_on  = [aws_waf_ipset.ipset, aws_waf_rule.wafrule]

    name        = local.cf_waf_acl
    metric_name = local.cf_waf_acl

    default_action {
        type = "BLOCK"
    }

    rules {
        action {
            type = "ALLOW"
        }

        priority = 1
        rule_id  = aws_waf_rule.wafrule.id
        type     = "REGULAR"
    }
}
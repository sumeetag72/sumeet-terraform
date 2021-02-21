locals {
  docusaurus_bucket_name = format("%s.%s.docusaurus", var.environment, var.project)
  storybook_bucket_name  = format("%s.%s.storybook", var.environment, var.project)
  finsemble_bucket_name  = format("%s.%s.finsemble", var.environment, var.project)
  example_bucket_name  = format("%s.%s.simple-app", var.environment, var.project)
}

resource "aws_s3_bucket" "finsemble" {
  bucket = local.finsemble_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.finsemble_bucket_name
  })

  tags = {
    Name        = "Product"
    Environment = "SeaHorse"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "finsemble_distribution" {
  origin {
    domain_name = aws_s3_bucket.finsemble.bucket_regional_domain_name
    origin_id   = local.finsemble_bucket_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "web", var.domain_name)]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.finsemble_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version="TLSv1.2_2019"
  }

  web_acl_id = var.seahorse_web_acl_id
}

resource "aws_s3_bucket" "docusaurus" {
  bucket = local.docusaurus_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.docusaurus_bucket_name
  })

  tags = {
    Name        = "Product"
    Environment = "SeaHorse"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "docs_distribution" {
  origin {
    domain_name = aws_s3_bucket.docusaurus.bucket_regional_domain_name
    origin_id   = local.docusaurus_bucket_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "docs", var.domain_name)]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.docusaurus_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }


  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version="TLSv1.2_2019"
  }

  web_acl_id = var.seahorse_web_acl_id
}

resource "aws_s3_bucket" "storybook" {
  bucket = local.storybook_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.storybook_bucket_name
  })

  tags = {
    Name        = "Product"
    Environment = "SeaHorse"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "storybook_distribution" {
  origin {
    domain_name = aws_s3_bucket.storybook.bucket_regional_domain_name
    origin_id   = local.storybook_bucket_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "storybook", var.domain_name)]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.storybook_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version="TLSv1.2_2019"
  }

  web_acl_id = var.seahorse_web_acl_id
}

resource "aws_s3_bucket" "examples" {
  bucket = local.example_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.example_bucket_name
  })

  tags = {
    Name        = "Product"
    Environment = "SeaHorse"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "examples_distribution" {
  origin {
    domain_name = aws_s3_bucket.finsemble.bucket_regional_domain_name
    origin_id   = local.example_bucket_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "web", var.domain_name)]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.example_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version="TLSv1.2_2019"
  }

  web_acl_id = var.seahorse_web_acl_id
}
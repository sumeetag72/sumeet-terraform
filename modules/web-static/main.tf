locals {
  docusaurus_bucket_name = format("%s.%s.docusaurus", var.environment, var.project)
  storybook_bucket_name  = format("%s.%s.storybook", var.environment, var.project)
  finsemble_bucket_name  = format("%s.%s.finsemble", var.environment, var.project)
  example_bucket_name  = format("%s.%s.simple-app", var.environment, var.project)
  apps_bucket_name  = format("%s.%s.apps", var.environment, var.project)
}

resource "aws_cloudfront_origin_access_identity" "finsemble_origin_access_identity" {
  comment = "Finsemble OAI"
}

resource "aws_s3_bucket" "finsemble" {
  bucket = local.finsemble_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.finsemble_bucket_name
    cdn_iam_arn = aws_cloudfront_origin_access_identity.finsemble_origin_access_identity.iam_arn
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

resource "aws_s3_bucket" "apps" {
  bucket = local.apps_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.apps_bucket_name
    cdn_iam_arn = aws_cloudfront_origin_access_identity.finsemble_origin_access_identity.iam_arn
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
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.finsemble_origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.apps.bucket_regional_domain_name
    origin_id   = local.apps_bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.finsemble_origin_access_identity.cloudfront_access_identity_path
    }
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
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/apps/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.apps_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
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

resource "aws_cloudfront_origin_access_identity" "docusaurus_origin_access_identity" {
  comment = "Docusaurus OAI"
}

resource "aws_s3_bucket" "docusaurus" {
  bucket = local.docusaurus_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.docusaurus_bucket_name
    cdn_iam_arn = aws_cloudfront_origin_access_identity.docusaurus_origin_access_identity.iam_arn
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
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.docusaurus_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "docusaurus", var.domain_name)]

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
    default_ttl            = 0
    max_ttl                = 0
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

resource "aws_cloudfront_origin_access_identity" "storybook_origin_access_identity" {
  comment = "StoryBook OAI"
}

resource "aws_s3_bucket" "storybook" {
  bucket = local.storybook_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.storybook_bucket_name
    cdn_iam_arn = aws_cloudfront_origin_access_identity.storybook_origin_access_identity.iam_arn
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
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.storybook_origin_access_identity.cloudfront_access_identity_path
    }
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
    default_ttl            = 0
    max_ttl                = 0
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

resource "aws_cloudfront_origin_access_identity" "example_origin_access_identity" {
  comment = "Examples OAI"
}

resource "aws_s3_bucket" "examples" {
  bucket = local.example_bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy/s3-buckets-policy.tpl", {
    bucket_name = local.example_bucket_name
    cdn_iam_arn = aws_cloudfront_origin_access_identity.example_origin_access_identity.iam_arn
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

resource "aws_cloudfront_distribution" "example_distribution" {
  origin {
    domain_name = aws_s3_bucket.examples.bucket_regional_domain_name
    origin_id   = local.example_bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [format("%s.%s", "simple-app", var.domain_name)]

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
    default_ttl            = 0
    max_ttl                = 0
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
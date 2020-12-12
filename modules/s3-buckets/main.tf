locals {
  docusaurus_bucket_name = format("%s.%s.test1", var.environment, var.project)
  storybook_bucket_name  = format("%s.%s.test2", var.environment, var.project)
  finsemble_bucket_name  = format("%s.%s.test", var.environment, var.project)
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
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
}

locals {
  docusaurus_bucket_name = format("%s.%s.test1", var.environment,var.project)
  storybook_bucket_name = format("%s.%s.test2", var.environment,var.project)
  finsemble_bucket_name = format("%s.%s.test", var.environment,var.project)
}

provider "aws" {
  profile = "276164198880_GL-ReleaseEngg"
  region  = var.region
}


resource "aws_s3_bucket" "finsemble" {
  bucket = local.finsemble_bucket_name
  acl    = "public-read"
  policy = templatefile("policy/s3-buckets-policy.tpl", {
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
  policy = templatefile("policy/s3-buckets-policy.tpl", {
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
  policy = templatefile("policy/s3-buckets-policy.tpl", {
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
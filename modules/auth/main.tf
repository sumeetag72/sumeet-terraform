resource "aws_cognito_user_pool" "seahorse_user_pool" {
  name                = "SeaHorse User Pool"
  username_attributes = ["email"]

  schema {
      name                = "email"
      attribute_data_type = "String"
      required            = true
    }
}

resource "aws_cognito_user_pool_client" "seahorse_web_client" {
  name                = "client"
  user_pool_id        = aws_cognito_user_pool.seahorse_user_pool.id
  generate_secret     = true
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_user_pool_domain" "seahorse_auth_domain" {
  domain       = format("%s-globallink", var.environment)
  user_pool_id = aws_cognito_user_pool.seahorse_user_pool.id
}

resource "aws_cognito_identity_pool" "seahorse_identity_pool" {
  identity_pool_name               = "SeaHorse Identity Pool"
  allow_unauthenticated_identities = false
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.seahorse_web_client.id
    provider_name           = aws_cognito_user_pool.seahorse_user_pool.endpoint
    server_side_token_check = false
  }
}

resource "aws_iam_role" "auth_iam_role" {
  name               = "auth_iam_role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
           {
                "Action": "sts:AssumeRole",
                "Principal": {
                     "Federated": "cognito-identity.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
           }
      ]
 }
 EOF
}

resource "aws_iam_role" "unauth_iam_role" {
  name               = "unauth_iam_role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
           {
                "Action": "sts:AssumeRole",
                "Principal": {
                     "Federated": "cognito-identity.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
           }
      ]
 }
 EOF
}

resource "aws_iam_role_policy" "web_iam_unauth_role_policy" {
  name   = "web_iam_unauth_role_policy"
  role   = aws_iam_role.unauth_iam_role.id
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
           {
                "Sid": "",
                "Action": "*",
                "Effect": "Deny",
                "Resource": "*"
           }
      ]
 }
 EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "seahorse_identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool.id
  roles = {
    authenticated   = aws_iam_role.auth_iam_role.arn
    unauthenticated = aws_iam_role.unauth_iam_role.arn
  }
}

resource "aws_cognito_identity_provider" "StateStreetAzure" {
  user_pool_id  = aws_cognito_user_pool.seahorse_user_pool.id
  provider_name = "StateStreetAzure"
  provider_type = "SAML"

  provider_details = {
    MetadataFile = file("${path.module}/metadata/dev-saml-metadata.xml")
  }

  attribute_mapping = {
    email    = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
  }
}
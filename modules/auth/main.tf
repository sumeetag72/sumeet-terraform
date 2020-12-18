resource "aws_cognito_user_pool" "seahorse_user_pool" {
  name                = "SeaHorse User Pool"
  username_attributes = ["email"]

  schema {
      name                = "email"
      attribute_data_type = "String"
      required            = true
      mutable             = true
    }
}

resource "aws_cognito_user_pool_client" "seahorse_web_client" {
  name                = "seahorse_web_client"
  user_pool_id        = aws_cognito_user_pool.seahorse_user_pool.id
  generate_secret     = false
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email","phone","openid","aws.cognito.signin.user.admin","profile"]
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = ["COGNITO",var.idp-name]
  callback_urls = var.user-pool-client-redirect-urls
  logout_urls = var.user-pool-client-logout-urls
  depends_on = [
    aws_cognito_identity_provider.identity_provider_sso
  ]
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

resource "aws_iam_role" "auth_web_iam_role" {
  name               = "auth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/auth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool.id
  })
  depends_on = [
    aws_cognito_identity_pool.seahorse_identity_pool
  ]
}

resource "aws_iam_role" "unauth_web_iam_role" {
  name               = "unauth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/unauth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool.id
  })
  depends_on = [
    aws_cognito_identity_pool.seahorse_identity_pool
  ]
}

resource "aws_iam_role_policy" "web_iam_unauth_role_policy" {
  name   = "web_iam_unauth_role_policy"
  role   = aws_iam_role.unauth_web_iam_role.id
  policy = file("${path.module}/policy/unauth_iam_role_policy.json")
}

resource "aws_cognito_identity_pool_roles_attachment" "seahorse_identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool.id
  roles = {
    authenticated   = aws_iam_role.auth_web_iam_role.arn
    unauthenticated = aws_iam_role.unauth_web_iam_role.arn
  }
}

resource "aws_cognito_identity_provider" "identity_provider_sso" {
  user_pool_id  = aws_cognito_user_pool.seahorse_user_pool.id
  provider_name = var.idp-name
  provider_type = "SAML"

  provider_details = {
    MetadataFile = file("${path.module}/metadata/${var.environment}-saml-metadata.xml")
  }

  attribute_mapping = {
    email    = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
  }
}
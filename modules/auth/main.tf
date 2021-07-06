resource "aws_cognito_user_pool" "seahorse_user_pool" {
  name                = "SeaHorse User Pool"
  username_attributes = ["email"]

  schema {
      name                = "email"
      attribute_data_type = "String"
      required            = true
      mutable             = true
    }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cognito_user_pool_client" "seahorse_web_client" {
  count   = var.deploy_auth ? 1 : 0
  name                = "seahorse_web_client"
  user_pool_id        = aws_cognito_user_pool.seahorse_user_pool[count.index].id
  generate_secret     = false
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email","phone","openid","aws.cognito.signin.user.admin","profile"]
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = ["COGNITO",var.idp-name]
  access_token_validity                = 720
  id_token_validity                    = 720
  refresh_token_validity               = 721
  token_validity_units = {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }
  callback_urls = var.user-pool-client-redirect-urls
  logout_urls = var.user-pool-client-logout-urls
  depends_on = [
    aws_cognito_identity_provider.identity_provider_sso
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  count   = var.deploy_auth ? 1 : 0
  domain          = var.domain_name
  certificate_arn = var.acm_certificate_arn
  user_pool_id    = aws_cognito_user_pool.seahorse_user_pool[count.index].id

  depends_on = [
    aws_cognito_identity_provider.identity_provider_sso
  ]
}

resource "aws_cognito_identity_pool" "seahorse_identity_pool" {
  count   = var.deploy_auth ? 1 : 0
  identity_pool_name               = "SeaHorse Identity Pool"
  allow_unauthenticated_identities = false
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.seahorse_web_client[count.index].id
    provider_name           = aws_cognito_user_pool.seahorse_user_pool[count.index].endpoint
    server_side_token_check = false
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "auth_web_iam_role" {
  count   = var.deploy_auth ? 1 : 0
  name               = "auth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/auth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool[count.index].id
  })
  depends_on = [
    aws_cognito_identity_pool.seahorse_identity_pool
  ]
}

resource "aws_iam_role" "unauth_web_iam_role" {
  count   = var.deploy_auth ? 1 : 0
  name               = "unauth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/unauth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool[count.index].id
  })
  depends_on = [
    aws_cognito_identity_pool.seahorse_identity_pool
  ]
}

resource "aws_iam_role_policy" "web_iam_unauth_role_policy" {
  count   = var.deploy_auth ? 1 : 0
  name   = "web_iam_unauth_role_policy"
  role   = aws_iam_role.unauth_web_iam_role[count.index].id
  policy = file("${path.module}/policy/unauth_iam_role_policy.json")
}

resource "aws_cognito_identity_pool_roles_attachment" "seahorse_identity_pool_roles" {
  count   = var.deploy_auth ? 1 : 0
  identity_pool_id = aws_cognito_identity_pool.seahorse_identity_pool[count.index].id
  roles = {
    authenticated   = aws_iam_role.auth_web_iam_role[count.index].arn
    unauthenticated = aws_iam_role.unauth_web_iam_role[count.index].arn
  }
}

resource "aws_cognito_identity_provider" "identity_provider_sso" {
  count   = var.deploy_auth ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.seahorse_user_pool[count.index].id
  provider_name = var.idp-name
  provider_type = "SAML"

  provider_details = {
    MetadataFile = file("${path.module}/metadata/${var.environment}-saml-metadata.xml")
  }

  attribute_mapping = {
    email    = "emailaddress"
    profile = "glauth"
  }
  lifecycle {
    prevent_destroy = true
  }
}

output "user_pool_arn" {
  description = "ARN of the user pool"
  value       = join("", aws_cognito_user_pool.seahorse_user_pool[*].arn)
}
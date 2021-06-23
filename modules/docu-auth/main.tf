resource "aws_cognito_user_pool" "documentation_user_pool" {
  name                = "Documentation User Pool"
  username_attributes = ["email"]

  schema {
      name                = "email"
      attribute_data_type = "String"
      required            = true
      mutable             = true
    }
}

resource "aws_cognito_user_pool_client" "documentation_app_client" {
  name                = "documentation_app_client"
  user_pool_id        = aws_cognito_user_pool.documentation_user_pool.id
  generate_secret     = false
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email","phone","openid","aws.cognito.signin.user.admin","profile"]
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH","ALLOW_USER_SRP_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = ["COGNITO"]
  callback_urls = var.docs-user-pool-client-redirect-urls
  logout_urls = var.docs-user-pool-client-logout-urls
}

resource "aws_cognito_user_pool_domain" "documentation_app_client_domain" {
  domain       = var.docs_auth_domain
  user_pool_id = aws_cognito_user_pool.documentation_user_pool.id
}

resource "aws_cognito_user_pool_ui_customization" "documentation_app_client_ui" {
  client_id = aws_cognito_user_pool_client.documentation_app_client.id

  css        = var.login-css
  image_file = filebase64("${path.module}/logo/GL-Dark-Logo.png")

  # Refer to the aws_cognito_user_pool_domain resource's
  # user_pool_id attribute to ensure it is in an 'Active' state
  user_pool_id = aws_cognito_user_pool.documentation_user_pool.id

  depends_on = [
    aws_cognito_user_pool_domain.documentation_app_client_domain
  ]
}

resource "aws_cognito_identity_pool" "documentation_identity_pool" {

  identity_pool_name               = "Documentation Identity Pool"
  allow_unauthenticated_identities = false
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.documentation_app_client.id
    provider_name           = aws_cognito_user_pool.documentation_user_pool.endpoint
    server_side_token_check = false
  }
}

resource "aws_iam_role" "auth_web_iam_role" {
  name               = "auth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/auth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.documentation_identity_pool.id
  })
  depends_on = [
    aws_cognito_identity_pool.documentation_identity_pool
  ]
}

resource "aws_iam_role" "unauth_web_iam_role" {
  name               = "unauth_web_iam_role"
  assume_role_policy = templatefile("${path.module}/policy/unauth_iam_role_assume_policy.tpl", {
    identity_pool_id = aws_cognito_identity_pool.documentation_identity_pool.id
  })
  depends_on = [
    aws_cognito_identity_pool.documentation_identity_pool
  ]
}

resource "aws_iam_role_policy" "web_iam_unauth_role_policy" {
  name   = "web_iam_unauth_role_policy"
  role   = aws_iam_role.unauth_web_iam_role.id
  policy = file("${path.module}/policy/unauth_iam_role_policy.json")
}

resource "aws_cognito_identity_pool_roles_attachment" "seahorse_identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.documentation_identity_pool.id
  roles = {
    authenticated   = aws_iam_role.auth_web_iam_role.arn
    unauthenticated = aws_iam_role.unauth_web_iam_role.arn
  }
}

output "docs_user_pool_arn" {
  description = "ARN of the user pool"
  value       = join("", aws_cognito_user_pool.documentation_user_pool.arn)
}
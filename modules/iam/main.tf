resource "aws_iam_group" "seahorse_fxconnect" {
  name = "seahorse_fxconnect"
  path = "/users/"
}

resource "aws_iam_group_policy" "seahorse_fxconnect_policy" {
  name  = "seahorse_fxconnect_policy"
  group = aws_iam_group.seahorse_fxconnect.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy/admin-api-access-policy.tpl", {
    admin_api_id = var.admin_api_id
    group_id=var.fxconnect_group_id
    aws_account_id=var.fxconnect_group_id
  })
}

resource "aws_iam_group" "seahorse_tradenexus" {
  name = "seahorse_tradenexus"
  path = "/users/"
}

resource "aws_iam_group_policy" "seahorse_tradenexus_policy" {
  name  = "seahorse_tradenexus_policy"
  group = aws_iam_group.seahorse_tradenexus.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy/admin-api-access-policy.tpl", {
    admin_api_id = var.admin_api_id
    group_id=var.tradenexus_group_id
    aws_account_id=var.aws_account_id
  })
}

resource "aws_iam_group" "seahorse_bestx" {
  name = "seahorse_bestx"
  path = "/users/"
}

resource "aws_iam_group_policy" "seahorse_bestx_policy" {
  name  = "seahorse_bestx_policy"
  group = aws_iam_group.seahorse_bestx.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy/admin-api-access-policy.tpl", {
    admin_api_id = var.admin_api_id
    group_id=var.bestx_group_id
    aws_account_id=var.aws_account_id
  })
}

resource "aws_iam_group" "seahorse_ssa" {
  name = "seahorse_ssa"
  path = "/users/"
}

resource "aws_iam_group_policy" "seahorse_ssa_policy" {
  name  = "seahorse_ssa_policy"
  group = aws_iam_group.seahorse_ssa.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy/admin-api-access-policy.tpl", {
    admin_api_id = var.admin_api_id
    group_id=var.ssa_group_id
    aws_account_id=var.aws_account_id
  })
}

resource "aws_iam_group" "seahorse_admin" {
  name = "seahorse_admin"
  path = "/users/"
}

resource "aws_iam_group_policy" "seahorse_admin_policy" {
  name  = "seahorse_admin_policy"
  group = aws_iam_group.seahorse_admin.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy/admin-api-seahorse-access-policy.tpl", {
    admin_api_id = var.admin_api_id
    group_id=var.seahorse_admin_group_id
    aws_account_id=var.aws_account_id
  })
}
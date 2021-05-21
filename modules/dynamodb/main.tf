resource "aws_dynamodb_table" "component-table" {
  name           = var.app_definitions_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 50
  write_capacity = 50
  hash_key       = "GROUP_ID"

  attribute {
    name = "GROUP_ID"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "user-preferences-table" {
  name           = var.user_preferences_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 50
  write_capacity = 50
  hash_key       = "user_id"
  range_key       = "preference_id"
  
  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "preference_id"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}
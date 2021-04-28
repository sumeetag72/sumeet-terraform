resource "aws_dynamodb_table" "component-dynamodb-table" {
  name           = var.app_definitions_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
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
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "USER_ID"
  range_key       = "PREFERENCE_ID"
  
  attribute {
    name = "USER_ID"
    type = "S"
  }

  attribute {
    name = "PREFERENCE_ID"
    type = "S"
  }

  attribute {
    name = "PREFERENCE_ID"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}
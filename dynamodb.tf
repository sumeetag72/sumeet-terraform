resource "aws_dynamodb_table" "component-dynamodb-table" {
  name           = "FSBL_CONFIG"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "APP_ID"

  attribute {
    name = "APP_ID"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Environment = var.environment
  }
}
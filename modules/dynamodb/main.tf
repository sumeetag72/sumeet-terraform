resource "aws_dynamodb_table" "component-dynamodb-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "APP_ID"

  attribute {
    name = "APP_ID"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }
}
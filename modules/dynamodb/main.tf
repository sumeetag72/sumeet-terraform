resource "aws_dynamodb_table" "component-dynamodb-table" {
  name           = var.table_name
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
}
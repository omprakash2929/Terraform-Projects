resource "aws_dynamodb_table" "Infra_dynamodb_table" {
  name = "${var.env}-infra-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = var.hash_key

  attribute {
    name = var.hash_key
    type = "s"
  }

  tags = {
    Name = "${var.env}-infra-table"
    Environment = var.env
  }
}
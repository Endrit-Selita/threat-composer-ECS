############### S3 Bucket ###############
resource "aws_s3_bucket" "mys3bucket-euwest2" {
  bucket = var.aws_s3_bucket_name
}

############### dynamoDB ###############
resource "aws_dynamodb_table" "dynamodb_terraform_lock" {
  name           = var.aws_dynamodb_table_name
  hash_key       = var.aws_dynamodb_table_hash_key
  read_capacity  = var.aws_dynamodb_table_read_capacity
  write_capacity = var.aws_dynamodb_table_write_capacity

  attribute {
    name = var.aws_dynamodb_table_attribute_name
    type = var.aws_dynamodb_table_attribute_type
  }
}
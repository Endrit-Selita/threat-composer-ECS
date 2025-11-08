variable "aws_s3_bucket_name" {
  type = string
  default = "mys3bucket-euwest2"
}

variable "aws_dynamodb_table_name" {
  type = string
  default = "dynamodb_terraform_lock"
}

variable "aws_dynamodb_table_hash_key" {
  type = string
  default = "LockID"
}

variable "aws_dynamodb_table_read_capacity" {
  type = number
  default = 20
}

variable "aws_dynamodb_table_write_capacity" {
  type = number
  default = 20
}

variable "aws_dynamodb_table_attribute_name" {
  type = string
  default = "LockID"
}

variable "aws_dynamodb_table_attribute_type" {
  type = string
  default = "S"
}
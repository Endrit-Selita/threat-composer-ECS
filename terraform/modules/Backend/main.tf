############### S3 Bucket ###############
resource "aws_s3_bucket" "mys3bucket-euwest2" {
  bucket = "mys3bucket-euwest2"
}

############### dynamoDB ###############
resource "aws_dynamodb_table" "dynamodb_terraform_lock" {
   name = "dynamodb_terraform_lock"
   hash_key = "LockID"
   read_capacity = 20
   write_capacity = 20

   attribute {
      name = "LockID"
      type = "S"
   }
}
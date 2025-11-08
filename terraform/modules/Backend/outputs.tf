output "aws_s3_bucket_arn" {
  description = "arn for iam policies to grant access to the bucket"
  value = aws_s3_bucket.mys3bucket-euwest2.arn
}

output "aws_s3_bucket_name" {
  description = "name for terraform state as most tools and backend configs use the name"
  value = aws_s3_bucket.mys3bucket-euwest2.bucket
}

output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.dynamodb_terraform_lock.arn
}

output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.dynamodb_terraform_lock.name
}
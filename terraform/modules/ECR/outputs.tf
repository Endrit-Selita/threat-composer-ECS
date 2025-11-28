output "ecr_app_id" {
  value = aws_ecr_repository.ecr_app.id
}

output "ecr_app_url" {
  description = "this is needed i can oush and pull images"
  value       = aws_ecr_repository.ecr_app.repository_url
}

output "ecr_app_arn" {
  description = "this arn is for IAM policies"
  value       = aws_ecr_repository.ecr_app.arn
}
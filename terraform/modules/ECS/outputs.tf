output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "aws_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.ecs_cloudwatch.name
}

output "kms_key" {
  value = aws_kms_key.kms_key.arn
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.service.arn
}

output "ecs_service" {
  value = aws_ecs_service.ecs_service.name
}

output "ecs_security_group" {
  value = aws_security_group.ecs_sg.id
}

###ECR###
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
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
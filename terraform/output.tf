output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = aws_lb.app_alb.arn
  description = "The ARN of the Application Load Balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app_tg.arn
  description = "The ARN of the Application Load Balancer Target Group"
}

output "ecs_service_name" {
  value       = aws_ecs_service.app_service.name
  description = "The name of the ECS service"
}

output "application_url" {
  value       = "http://${aws_lb.app_alb.dns_name}"
  description = "The URL of the deployed application"
}
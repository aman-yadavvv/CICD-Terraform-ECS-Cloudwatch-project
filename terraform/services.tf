resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false

  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "aman-strapi-container"
    container_port   = 1337
  }

  depends_on = [
    aws_lb_listener.app_listener
  ]
}
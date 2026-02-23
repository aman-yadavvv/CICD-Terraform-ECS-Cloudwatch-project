resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/app-task"
  retention_in_days = 30
}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "strapi-ecs-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.app_cluster.name,
              "ServiceName",
              aws_ecs_service.app_service.name,
              {
                stat = "Average"
              }
            ]
          ]
          period = 60
          region = var.aws_region
          title  = "ECS Service CPU Utilization"

        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.app_cluster.name,
              "ServiceName",
              aws_ecs_service.app_service.name,
              {
                stat = "Average"
              }
            ]
          ]
          period = 60
          region = var.aws_region
          title  = "ECS Service Memory Utilization"

        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              aws_db_instance.strapi_db.id,
              {
                stat = "Average"
              }
            ]
          ]
          period = 60
          region = var.aws_region
          title  = "RDS CPU Utilization"
        }
      }

    ]
  })
}
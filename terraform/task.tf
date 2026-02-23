# Note: The ECS service and task definitions will be created in the next steps, but we need to ensure the IAM role is set up first for the task execution.
# The ECS service will be created in the next step, which will reference the task definition and the target group for load balancing.

resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "aman-strapi-container"
      image     = var.app_image
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        # Database connection environment variables
        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.strapi_db.address },
        { name = "DATABASE_PORT", value = tostring(aws_db_instance.strapi_db.port) },
        { name = "DATABASE_NAME", value = aws_db_instance.strapi_db.db_name },
        { name = "DATABASE_USER", value = aws_db_instance.strapi_db.username },
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "DATABASE_SSL", value = "true" },
        { name = "DATABASE_SSL_REJECT_UNAUTHORIZED", value = "false" },

        # Application-specific environment variables
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "JWT_SECRET", value = var.jwt_secret },
        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
        { name = "ADMIN_AUTH_SECRET", value = var.admin_jwt_secret },
        { name = "NODE_ENV", value = "production" },

      ]


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/app-task"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
resource "aws_ecs_task_definition" "tis" {
  family                   = "final-ror-task-definition"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "2048"
  memory                   = "3072"
  execution_role_arn       = "arn:aws:iam::339713104321:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "app",
      image     = var.image_url,
      essential = true,
      portMappings = [{
        containerPort = 80,
        hostPort      = 80,
        protocol      = "tcp",
        appProtocol   = "http"
      }],
      cpu               = 512,
      memoryReservation = 512,
      memory            = 1024,
      environment = [
        { name = "RAILS_ENV",         value = "production" },
        { name = "DB_USER",           value = "myuser" },
        { name = "DB_PASSWORD",       value = "mypassword" },
        { name = "DB_HOST",           value = "rorchatapp.c342ea4cs6ny.ap-south-1.rds.amazonaws.com" },
        { name = "DB_PORT",           value = "5432" },
        { name = "DB_NAME",           value = "rorchatapp" },
        { name = "REDIS_URL",         value = "redis://redis:6379/0" },
        { name = "RAILS_MASTER_KEY",  value = "c3ca922688d4bf22ac7fe38430dd8849" },
        { name = "SECRET_KEY_BASE",   value = "600f21de02355f788c759ff862a2cb22ba84ccbf072487992f4c2c49ae260f87c7593a1f5f6cf2e45457c76994779a8b30014ee9597e35a2818ca91e33bb7233" }
      ],
      dependsOn = [{
        containerName = "redis",
        condition     = "START"
      }]
    },
    {
      name      = "redis",
      image     = "redis:7",
      essential = false,
      portMappings = [{
        containerPort = 6379
      }],
      cpu    = 256,
      memory = 512
    }
  ])
}

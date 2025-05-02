resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ECS-MyCluster" # Cluster Name

  setting {
    name  = "containerInsights"
    value = "enabled" #  Enable Container Insights
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [
    "ECS-MyCapacityProvider" #  Capacity Provider Name. Replace it
  ]

  default_capacity_provider_strategy {
    capacity_provider = "ECS-MyCapacityProvider" #  Capacity Provider Name. Replace it
    weight            = 100
    base              = 1
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "ECS-MyCapacityProvider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status            = "ENABLED"
      target_capacity = 100
    }
  }
}

variable "auto_scaling_group_arn" {
  type        = string
  description = "The ARN of the Auto Scaling Group to associate with the ECS Capacity Provider."
}

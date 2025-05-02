provider "aws" {
  region = "ap-south-1"
}

# Launch Template (already created)
resource "aws_launch_template" "my_template" {
  name_prefix   = "ECS-MyTemplate-"
  description   = "Launch template for EC2 instance"
  image_id      = "ami-0c1962fdaf1a23f7d"
  instance_type = "t3.medium"
  key_name      = "Myops"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = ["sg-0a35e9086b143cac5", "sg-0106a2994ff8e49aa"]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type  = "gp2"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_my_asg" {
  name                  = "ECS-MyASG"
  min_size              = 1
  max_size              = 5
  desired_capacity      = 1
  health_check_type     = "EC2"
  health_check_grace_period = 0
  vpc_zone_identifier = ["subnet-03b17848527227137", "subnet-04cf194b656ad564e", "subnet-0738b2e70f37fe442"]

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance - ror-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

# Lifecycle Hook for ASG
resource "aws_autoscaling_lifecycle_hook" "ecs_termination_hook" {
  name                       = "ecs-managed-draining-termination-hook"
  autoscaling_group_name = aws_autoscaling_group.ecs_my_asg.name
  default_result             = "CONTINUE"
  heartbeat_timeout          = 3600
  lifecycle_transition     = "autoscaling:EC2_INSTANCE_TERMINATING"
}

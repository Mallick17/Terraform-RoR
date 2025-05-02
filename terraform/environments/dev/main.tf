provider "aws" {
  region = "ap-south-1" #  set your region
}
# Call the modules

module "ec2_autoscaling" {
  source = "../../modules/ec2-autoscaling"
}

module "ecs_cluster" {
  source = "../../modules/ecs"
  auto_scaling_group_arn = data.aws_autoscaling_group.ecs_my_asg.arn
}

module "codebuild" {
  source = "../../modules/codebuild"
}

data "aws_autoscaling_group" "ecs_my_asg" {
  name = "ECS-MyASG"
}

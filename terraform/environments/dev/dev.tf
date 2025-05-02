provider "aws" {
  region = "ap-south-1" # Or your desired region
}

module "ecs_cluster" {
  source = "../../modules/ecs"

  #  Include the autoscaling group arn.
  auto_scaling_group_arn = aws_autoscaling_group.ecs_my_asg.arn
}

#  Import the autoscaling group.
data "aws_autoscaling_group" "ecs_my_asg" {
  arn = "arn:aws:autoscaling:ap-south-1:339713104321:autoScalingGroup:28849479-f111-4475-87e3-99999EXAMPLE:autoScalingGroupName/ECS-MyASG" # Replace with your actual ASG ARN
}

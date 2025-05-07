variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ecr_name" {
  default = "terraform-rails-app"
}

variable "ecs_cluster" {
  default = "terraform-rails-cluster"
}

variable "codebuild_project" {
  default = "terraform-rails-build"
}

variable "vpc_id" {
  default = "vpc-02853bd379618f5ca"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-0738b2e70f37fe442",
    "subnet-04cf194b656ad564e",
    "subnet-03b17848527227137"
  ]
}

variable "security_group_id" {
  default = "sg-0a35e9086b143cac5"
}

variable "launch_template_asg" {
  default = "arn:aws:autoscaling:ap-south-1:339713104321:autoScalingGroup:795ad0c2-699f-434b-b024-097369afc718:autoScalingGroupName/terraform-ecs-ror-asg"
  type    = string
}

variable "codebuild_role_arn" {
   default = "arn:aws:iam::339713104321:role/codebuild-ror-app-role"
   type    = string
}

#variable "codebuild_role_arn" {
#  type = string
#}

variable "github_repo" {
  type = string
  default = "ROR-AWS-ECS"
}

variable "github_owner" {
  type = string
  default = "Mallick17"
}

variable "git_branch" {
  type    = string
  default = "master"
}

variable "github_branch" {
  description = "GitHub branch to build from"
  type        = string
}

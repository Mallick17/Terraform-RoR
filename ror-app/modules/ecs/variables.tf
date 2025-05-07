variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "image_url" {
  description = "The image URL to deploy"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "asg_arn" {
  description = "ARN of the AutoScalingGroup"
  type        = string
}

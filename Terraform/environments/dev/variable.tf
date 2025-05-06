variable "subnet_ids" {
  description = "List of subnet IDs for the EC2 instances"
  type        = list(string)
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "ec2_security_group_names" {
  description = "List of security group names"
  type        = list(string)
}

variable "user_data" {
  description = "User data for EC2 instances"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for the environment"
  type        = string
}

module "ec2_autoscaling" {
  source = "../../modules/ec2_autoscaling"

  # EC2 Instance Configuration
  key_name          = var.key_name
  ami_id            = var.ami_id
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type
  subnet_ids        = var.subnet_ids
  instance_profile_name = var.instance_profile_name
  ec2_security_group_names = var.ec2_security_group_names
  security_group_ids = var.ec2_security_groups
  user_data         = var.user_data
  environment       = var.environment
  project_name      = var.project_name
}

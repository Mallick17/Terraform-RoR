# General
environment     = "dev"
project_name    = "ror-ecs-project"

# EC2 / ECS Auto Scaling Configuration
instance_type           = "t3.medium"
key_name                = "Myops"
ami_id                  = "ami-08fe5144e4659a3b3"
instance_profile_name   = "ecsInstanceProfile"
ec2_security_group_names = ["default", "All_Security"]
ec2_security_groups     = ["sg-0106a2994ff8e49aa", "sg-0a35e9086b143cac5"]
min_size                = 1
max_size                = 2
desired_capacity        = 1
subnet_ids              = [
  "subnet-0738b2e70f37fe442", # ap-south-1a
  "subnet-04cf194b656ad564e", # ap-south-1c
  "subnet-03b17848527227137"  # ap-south-1b
]

# ECS Service
cluster_name             = "ror-ecs-cluster"
service_name             = "ror-app-service"
task_definition_family   = "ror-task"
requires_compatibilities = ["EC2"]
cpu                      = 256
memory                   = 512
launch_type              = "EC2"
assign_public_ip         = false
security_group_ids       = ["sg-0a35e9086b143cac5", "sg-0106a2994ff8e49aa"]
execution_role_arn       = "arn:aws:iam::339713104321:role/ecsTaskExecutionRole"
task_role_arn            = "arn:aws:iam::339713104321:role/ecsTaskExecutionRole"
ecr_repository_url       = "339713104321.dkr.ecr.ap-south-1.amazonaws.com/terraform-final-ror-ecr"
desired_count            = 1

# ECS App Environment Variables
environment_variables = [
  {
    name  = "RAILS_ENV"
    value = "production"
  },
  {
    name  = "DATABASE_HOST"
    value = "your-db-host"
  },
  {
    name  = "DATABASE_NAME"
    value = "your-db-name"
  },
  {
    name  = "DATABASE_USERNAME"
    value = "your-db-user"
  },
  {
    name  = "DATABASE_PASSWORD"
    value = "your-db-password"
  },
  {
    name  = "REDIS_URL"
    value = "redis://localhost:6379/0"
  }
]

# CodeBuild Configuration
source_repo         = "https://github.com/Mallick17/ROR-AWS-ECS"
buildspec           = "buildspec.yml"
codebuild_role_arn  = "arn:aws:iam::339713104321:role/codebuild-ror-app-role"

# S3 Artifact Bucket
artifact_bucket_name = "codepipeline-ap-south-1-7417d7b4a8e3-4a7d-b09d-2028b1076a80"
artifact_bucket_arn  = "arn:aws:s3:::codepipeline-ap-south-1-7417d7b4a8e3-4a7d-b09d-2028b1076a80"

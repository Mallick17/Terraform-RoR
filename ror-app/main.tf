provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source     = "./modules/ecr"
  name   = var.ecr_name
  aws_region = var.aws_region
}

module "ecs" {
  source              = "./modules/ecs"
  cluster_name        = var.ecs_cluster
  image_url           = module.ecr.ecr_repo_url
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  security_group_id   = var.security_group_id
  asg_arn             = var.launch_template_asg
}

#  module "s3" {
#  source       = "./modules/s3"
#  bucket_name  = var.artifact_bucket
#  force_destroy = true
# }

module "codebuild" {
  source           = "./modules/codebuild"
  project_name     = var.codebuild_project
  service_role_arn = var.codebuild_role_arn
  github_repo      = var.github_repo
  github_owner     = var.github_owner
  github_branch    = var.github_branch
##  artifact_bucket  = "s3://codepipeline-ap-south-1-7417d7b4a8e3-4a7d-b09d-2028b1076a80/mallow-ecs-ror-final/"
}

# module "codepipeline" {
#  source              = "./modules/codepipeline"
#  pipeline_name       = var.pipeline_name
#  artifact_bucket     = module.s3.bucket_name
#  codebuild_project   = module.codebuild.project_name
#  github_repo         = var.github_repo
#  github_owner        = var.github_owner
#  github_branch       = var.github_branch
#  github_oauth_token  = var.github_oauth_token
#  role_arn            = var.pipeline_role_arn
#}

# Set image_url from ECR output
locals {
  image_url = module.ecr.ecr_repo_url
}

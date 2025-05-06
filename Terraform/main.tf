provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source     = "./modules/ecr"
  name       = var.ecr_name
  aws_region = var.aws_region
}

module "ecs" {
  source            = "./modules/ecs"
  cluster_name      = var.ecs_cluster
  image_url         = module.ecr.ecr_repo_url
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  security_group_id = var.security_group_id
  asg_arn           = var.asg_arn
}

module "codebuild" {
  source        = "./modules/codebuild"
  project       = var.codebuild_project
  ecr_image_url = module.ecr.ecr_repo_url
}

module "codepipeline" {
  source              = "./modules/codepipeline"
  pipeline_name       = var.pipeline_name
  github_repo         = var.github_repo
  github_owner        = var.github_owner
  github_branch       = var.github_branch
  github_token        = var.github_token
  codebuild_project   = module.codebuild.codebuild_project_name
  ecr_repo_url        = module.ecr.ecr_repo_url
  ecs_cluster_name    = module.ecs.cluster_name
  ecs_service_name    = "${var.ecs_cluster}-service"
  ecs_container_name  = var.ecs_container_name
  ecs_image_name      = var.ecr_name
}

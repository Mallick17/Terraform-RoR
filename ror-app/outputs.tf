output "ecr_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.ecr_repo_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "codebuild_project_name" {
  value = module.codebuild.project_name
}

#output "artifact_bucket_name" {
#  value = module.s3.bucket_name
#}

#output "pipeline_name" {
#  value = module.codepipeline.pipeline_name
#}

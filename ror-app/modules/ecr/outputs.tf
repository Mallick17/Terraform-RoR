output "ecr_repo_url" {
  description = "The URL of the ECR repository"
  value = aws_ecr_repository.this.repository_url
}

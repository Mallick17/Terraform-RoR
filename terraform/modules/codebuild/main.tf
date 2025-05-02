resource "aws_codebuild_project" "ecs_codebuild_project" {
  name          = "ECS-MyCodeBuild" # Updated project name
  description   = "CodeBuild project for ECS deployments" # Added description
  service_role  = "arn:aws:iam::339713104321:role/codebuild-ror-app-role" # Use the correct service role ARN

  artifacts {
    type = "NO_ARTIFACTS" # No artifacts are stored
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # Enable privileged mode if your build requires Docker
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/Mallick17/ROR-AWS-ECS" # Your GitHub repository

    git_clone_depth = 1
    buildspec       = "buildspec.yml" # Path to your buildspec file
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}

# Create an ECR repository to store the Docker image
resource "aws_ecr_repository" "my_app_repo" {
  name                 = "ecs-my-ecr" #  name for your repository.  Changed to lowercase and dash
  image_tag_mutability = "MUTABLE" # or MUTABLE
}

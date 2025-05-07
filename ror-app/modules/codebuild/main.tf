resource "aws_codebuild_project" "this" {
  name         = var.project_name
  service_role = var.service_role_arn

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }

    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type     = "BUILD_GENERAL1_SMALL"
    image            = "aws/codebuild/standard:7.0"
    type             = "LINUX_CONTAINER"
    privileged_mode  = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}

resource "null_resource" "trigger_codebuild" {
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${var.project_name}"
  }

#  depends_on = [module.codebuild] # Make sure CodeBuild module finishes first
}

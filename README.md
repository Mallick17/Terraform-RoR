# Terraform-RoR
## File Structure
```
terraform/
├── backend.tf
├── environments
│   └── dev
│       ├── main.tf
│       ├── terraform.tfstate
│       ├── terraform.tfvars
│       ├── userdata.sh
│       └── variables.tf
├── iam.tf
└── modules
    ├── codebuild
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── codepipeline
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── ec2_autoscaling
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── ecr
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    ├── ecs_service
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── task_definition.tf
    │   └── variables.tf
    └── s3-artifact-store
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

# Terraform: Simple Module-by-Module Deployment

We’ll build in three clear steps—first ECR, then ECS, then CodeBuild—verifying as we go. Each module takes just the essentials so you can focus on testing, not on endless inputs.

Make sure your folder structure looks like this:

```
project-root/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── ecr/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    # Create these only when needed:
    # ├── ecs/
    # │   ├── main.tf
    # │   ├── variables.tf
    # │   └── outputs.tf
    # └── codebuild/
    #     ├── main.tf
    #     ├── variables.tf
    #     └── outputs.tf
```

**Important:**

* Run Terraform commands from the root directory (`project-root/`).
* Do not reference `ecs` or `codebuild` modules in `main.tf` unless their folders actually exist.
* Every `.tf` file must end with a newline. Terraform will fail without it.

---

## Step 1: Root - `main.tf`

Start with **only the ECR module** included:

```hcl
provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"
  name   = var.ecr_name
}

# Enable this only after creating the ECS module folder
# module "ecs" {
#   source         = "./modules/ecs"
#   cluster_name   = var.ecs_cluster
#   image_url      = module.ecr.url
# }

# Enable this only after creating the CodeBuild module folder
# module "codebuild" {
#   source        = "./modules/codebuild"
#   project       = var.codebuild_project
#   ecr_image_url = module.ecr.url
# }
```

---

## Root - `variables.tf`

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "ecr_name" {
  default = "rails-app"
}

variable "ecs_cluster" {
  default = "rails-cluster"
}

variable "codebuild_project" {
  default = "rails-build"
}
```

---

## Step 2: Module - ECR

### `modules/ecr/main.tf`

```hcl
resource "aws_ecr_repository" "this" {
  name = var.name
}
```

### `modules/ecr/variables.tf`

```hcl
variable "name" {}
```

### `modules/ecr/outputs.tf`

```hcl
output "url" {
  value = aws_ecr_repository.this.repository_url
}
```

---

## Step 3: Test the ECR Module

1. Go to the root directory (`project-root/`).
2. Run:

```bash
terraform init
terraform apply -target=module.ecr
```

3. Check:

   * ECR repository is created in AWS Console
   * Output shows repository URL

---

Absolutely! Here's a **detailed line-by-line explanation** of each section of your AWS CodeBuild Terraform script, in the same style and format you're using:

---

```hcl
resource "aws_codebuild_project" "this" {         ## we are using AWS CodeBuild service to define a build project
  name          = var.project_name                ## project name is pulled from a variable defined in variables.tf
  description   = "CodeBuild project for ECS-deployed Ruby on Rails app"  ## optional description to clarify purpose
  build_timeout = 20                              ## maximum duration a build can run is set to 20 minutes (after which it will timeout)
  service_role  = var.codebuild_service_role_arn  ## IAM role ARN that gives CodeBuild permissions to access AWS resources like S3, ECR, etc.
```

---

```hcl
  artifacts {
    type = "NO_ARTIFACTS"                         ## specifies that this build does not produce any artifacts (e.g., zip, .jar, etc.)
                                                  ## this is typically used when you're pushing images or using external tools instead
  }
```

---

```hcl
  environment {
    compute_type     = "BUILD_GENERAL1_SMALL"     ## allocates small compute resources: 3 vCPUs, 3 GB RAM
                                                  ## other options: MEDIUM (7 GB), LARGE (15 GB) depending on build requirements

    image            = "aws/codebuild/standard:7.0" ## uses AWS-managed Docker image (version 7.0) with pre-installed runtimes/tools
                                                  ## includes languages like Python, Node.js, Java, Docker, etc.

    type             = "LINUX_CONTAINER"          ## defines the OS type of the environment container; here, it’s a Linux-based container

    privileged_mode  = true                       ## enables Docker-in-Docker functionality (needed for building and pushing Docker images)
                                                  ## if false, Docker commands inside the buildspec will fail
```

---

```hcl
    environment_variable {
      name  = "REPOSITORY_URI"                    ## defines a custom environment variable used in the build process
      value = var.ecr_repository_url              ## its value is pulled from a variable; typically the target Amazon ECR repo URL
    }
  }
```

---

```hcl
  source {
    type            = "GITHUB"                    ## specifies that the source code is hosted on GitHub
    location        = var.github_repo_url         ## the URL of the GitHub repository is defined via a variable
    git_clone_depth = 1                           ## performs a shallow clone of just the latest commit to speed up the build
    buildspec       = var.buildspec_path          ## path to the buildspec.yml file which defines build phases and commands
  }
```

---

```hcl
  source_version = var.source_version             ## allows you to specify a specific Git branch, tag, or commit ID to build from
}
```

---

```hcl
resource "null_resource" "trigger_codebuild_build" {  ## helper resource to trigger a CodeBuild build automatically
  triggers = {
    always_run = timestamp()                     ## ensures this resource always changes by setting a unique timestamp
                                                  ## this triggers the local-exec provisioner on every `terraform apply`
  }

  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${aws_codebuild_project.this.name} --region ap-south-1"
                                                  ## uses AWS CLI to start a new build for the specified CodeBuild project
                                                  ## ensure AWS CLI is installed and configured locally where Terraform is running
  }

  depends_on = [aws_codebuild_project.this]       ## ensures that the CodeBuild project is created before trying to trigger a build
}
```

---




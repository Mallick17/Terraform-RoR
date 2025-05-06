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


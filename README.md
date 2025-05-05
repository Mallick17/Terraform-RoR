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


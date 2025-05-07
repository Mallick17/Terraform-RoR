variable "project_name" {
  type = string
}

variable "github_repo" {
  type = string
  default = "https://github.com/Mallick17/ROR-AWS-ECS.git"
}

variable "github_owner" {
  type = string
  default = "Mallick17"
}

variable "service_role_arn" {
  type = string
  default = "arn:aws:iam::339713104321:role/service-role/codebuild-ror-chat-app-build-service-role"
}

variable "s3_bucket" {
  type = string
  default = "s3://codepipeline-ap-south-1-7417d7b4a8e3-4a7d-b09d-2028b1076a80/mallow-ecs-ror-final"
}

variable "github_branch" {
  type = string
}

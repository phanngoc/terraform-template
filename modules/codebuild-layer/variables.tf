#modules/codebuild-layer/variables.tf
variable "env" {}
variable "project" {}
variable "region" {}


variable "name" {
  type        = string
  description = "The projects name."
}

variable "artifact_bucket_arn" {
  default     = "arn:aws:s3:::*"
  type        = string
  description = "The S3 Bucket ARN of artifacts."
}

variable "environment_type" {
  default     = "LINUX_CONTAINER"
  type        = string
  description = "The type of build environment to use for related builds."
}

variable "compute_type" {
  default     = "BUILD_GENERAL1_SMALL"
  type        = string
  description = "Information about the compute resources the build project will use."
}

variable "image" {
  default     = "aws/codebuild/ubuntu-base:14.04"
  type        = string
  description = "The image identifier of the Docker image to use for this build project."
}

variable "privileged_mode" {
  default     = true
  type        = bool
  description = "If set to true, enables running the Docker daemon inside a Docker container."
}

variable "buildspec" {
  default     = ""
  type        = string
  description = "The build spec declaration to use for this build project's related builds."
}

variable "cache_type" {
  default     = "NO_CACHE"
  type        = string
  description = "The type of storage that will be used for the AWS CodeBuild project cache."
}

variable "cache_location" {
  default     = ""
  type        = string
  description = "The location where the AWS CodeBuild project stores cached resources."
}

variable "encryption_key" {
  default     = ""
  type        = string
  description = "The KMS CMK to be used for encrypting the build project's build output artifacts."
}

variable "build_timeout" {
  default     = 60
  type        = string
  description = "How long in minutes to wait until timing out any related build that does not get marked as completed."
}

variable "enabled_ecr_access" {
  default     = true
  type        = bool
  description = "If set to true, enables access to ECR."
}

variable "ecr_access_policy_arn" {
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  type        = string
  description = "The ARN specifying the IAM Role for ECR access."
}

variable "iam_path" {
  default     = "/"
  type        = string
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}


variable "git_repository_owner" {
  type        = string
}

variable "git_repository_name" {
  type        = string
}

variable "git_repository_branch" {
  default     = "main"
  type        = string
}

variable "github_oauth_token" {
  default     = ""
  type        = string
}

variable "ecs_cluster_name" {
  type        = string
}

variable "ecs_service_name" {
  type        = string
}

variable "codedeploy_application_name" {
  type        = string
}

variable "codedeploy_group_name" {
  type        = string
}

variable "account" {
  type        = string
}

variable "image_project" {
  type        = string
  description = "Image name build by docker for project "
}
variable "account" {
  description = "Account aws"
  type        = string
  default     = "360631776925"
}

#modules/application-layer/variables.tf
variable "ecs_key_pair_name" {
  description = "Key name SSH to EC2"
  type        = string
  default     = "lab"
}

variable "ecs_cluster" {
  description = "Name ecs cluster"
  type        = string
}

variable "asg_max_instance_size" {
  type = number
  description = "Maximum number of instances in the cluster"
}

variable "asg_min_instance_size" {
  type = number
  description = "Minimum number of instances in the cluster"
}

variable "asg_desired_capacity" {
  type = number
  description = "Desired number of instances in the cluster"
}

variable "ecs_desired_capacity" {
  type = number
  description = "Desired number of instances in the cluster"
}

variable "github_oauth_token" {
  type = string
  description = "secret token github"
}

#modules/network-layer/variables.tf
variable "env" {
  type = string
}
variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_cidrs" {
  type = list(string)
}

variable "public_cidrs" {
  type = list(string)
}

variable "image_project" {
  type = string
}

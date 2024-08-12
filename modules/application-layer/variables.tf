variable "account" {
  description = "Account aws"
  type        = string
  default     = "395044016922"
}

variable "ecs_key_pair_name" {
  description = "name key SSH to EC2"
  type        = string
  default     = "lab"
}

variable "ecs_cluster" {
  description = "Name of cluster"
  type        = string
  default     = "name demo"
}

variable "asg_max_instance_size" {
  type        = number
  description = "Maximum number of instances in the cluster"
}

variable "asg_min_instance_size" {
  type        = number
  description = "Minimum number of instances in the cluster"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in the cluster"
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

variable "iac_standard_vpc_id" {
  type = string
}

variable "iac_standard_subnet_public_id" {
  type = list(string)
}

variable "iac_standard_subnet_private_id" {
  type = list(string)
}

variable "ecs_desired_capacity" {
  type = number
}
# variable "deployment_group_name" {
#   type = string
# }
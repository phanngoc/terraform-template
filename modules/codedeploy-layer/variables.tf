#modules/codedeploy-layer/variables.tf
variable "env" {}
variable "project" {}
variable "region" {}
variable "iac_standard_ruby_autoscale_group_name" {}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "lb_listener_arn" {
  type = string
}

variable "lb_target_group_name" {
  type = string
}

variable "alb_target_grp_name_green" {
  type = string
}
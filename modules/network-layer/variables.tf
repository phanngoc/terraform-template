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

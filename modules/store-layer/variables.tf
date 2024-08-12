#modules/store-layer/variables.tf
variable "project" {}
variable "env" {}
variable "region" {}
variable "subnet_ids" {
  type = list(any)
}

variable "domain_es" {
  description = "Name of the domain es"
  type        = string
}


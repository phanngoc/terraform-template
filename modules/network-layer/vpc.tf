provider "aws" {
  region = "us-east-2"
}

#1. VPC
resource "aws_vpc" "iac_standard_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.project}-vpc-${var.env}"
    Stage = "${var.env}"
  }
}

data "aws_availability_zones" "available" {}

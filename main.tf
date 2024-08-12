provider "aws" {
  region = "us-east-2"
  profile = "usertest1"
}

# resource "aws_instance" "ec2_instance" {
#   ami                    = "ami-03921a191ab15cae7"
#   subnet_id              = module.network-layer.iac_standard_subnet_public_id[0]
#   instance_type          = "t2.micro"
#   iam_instance_profile   = aws_iam_instance_profile.ecs-instance-profile.name  #CHANGE THIS
#   vpc_security_group_ids = ["sg-0b9c82713c416f6dd"]
#   key_name               = var.ecs_key_pair_name
#   user_data            = <<EOF
# #!/bin/bash
# echo 'ECS_CLUSTER=${var.ecs_cluster}' >> /etc/ecs/ecs.config
# EOF
# }

#-----------NETWORK-LAYER MODULE-------------
module "network-layer" {
  source        = "./modules/network-layer"
  env           = var.env
  project       = var.project
  region        = var.region
  vpc_cidr      = var.vpc_cidr
  private_cidrs = var.private_cidrs
  public_cidrs  = var.public_cidrs
}

module "application-layer" {
  source        = "./modules/application-layer"
  env           = var.env
  project       = var.project
  region        = var.region
  vpc_cidr      = var.vpc_cidr
  private_cidrs = var.private_cidrs
  public_cidrs  = var.public_cidrs
  account       = var.account

  ecs_cluster   = var.ecs_cluster
  ecs_key_pair_name   = var.ecs_key_pair_name
  ecs_desired_capacity = var.ecs_desired_capacity

  # ASG EC2 size
  asg_max_instance_size = var.asg_max_instance_size
  asg_min_instance_size = var.asg_min_instance_size
  asg_desired_capacity = var.asg_desired_capacity

  iac_standard_vpc_id = module.network-layer.iac_standard_vpc_id
  iac_standard_subnet_public_id = module.network-layer.iac_standard_subnet_public_id
  iac_standard_subnet_private_id = module.network-layer.iac_standard_subnet_private_id
}

#-----------CODEDEPLOY-LAYER MODULE---------
module "codedeploy-layer" {
  source                                 = "./modules/codedeploy-layer"
  env                                    = var.env
  project                                = var.project
  region                                 = var.region
  iac_standard_ruby_autoscale_group_name = module.application-layer.iac_standard_ruby_autoscale_group_name
  ecs_service_name = module.application-layer.ecs_service_name
  ecs_cluster_name = module.application-layer.ecs_cluster_name

  lb_listener_arn = module.application-layer.lb_listener_arn
  lb_target_group_name = module.application-layer.alb_target_grp_blue_name
  alb_target_grp_name_green = module.application-layer.alb_target_grp_name_green
}

module "codebuild" {
  source = "./modules/codebuild-layer"
  name   = "${var.project}-codebuild-${var.env}"

  env                                    = var.env
  project                                = var.project
  region                                 = var.region
  image_project                          = var.image_project
  account                                = var.account

  # artifact_bucket_arn = aws_s3_bucket.artifact.arn
  environment_type    = "LINUX_CONTAINER"
  compute_type        = "BUILD_GENERAL1_SMALL"
  image               = "aws/codebuild/docker:18.09.0"
  privileged_mode     = true
  buildspec           = "app/buildspec.yml"
  # cache_type          = "S3"
  # cache_location      = "${aws_s3_bucket.artifact.id}/codebuild"
  encryption_key      = ""
  build_timeout       = 10
  iam_path            = "/service-role/"
  description         = "Build for image fargate"

  enabled_ecr_access    = true
  ecr_access_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"

  git_repository_owner = "ngocp-0847"
  git_repository_name = "example-fargate"
  git_repository_branch = "main"
  github_oauth_token = var.github_oauth_token
  tags = {
    Environment = var.env
  }

  ecs_cluster_name = module.application-layer.ecs_cluster_name
  ecs_service_name = module.application-layer.ecs_service_name
  codedeploy_application_name = module.codedeploy-layer.codedeploy_application_name
  codedeploy_group_name = module.codedeploy-layer.codedeploy_group_name
  # deployment_group_name = module.application-layer.deployment_group_name
}

module "store-layer" {
  source                                 = "./modules/store-layer"
  env                                    = var.env
  project                                = var.project
  region                                 = var.region
  subnet_ids                             = module.network-layer.iac_standard_subnet_private_id
  domain_es                              = "wnote-es"
}
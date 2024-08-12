resource "aws_codedeploy_app" "iac_standard_codedeploy_app" {
  compute_platform = "ECS"
  name             = "${var.project}-ec2-codedeploy-app-${var.env}"
}

resource "aws_codedeploy_deployment_group" "iac_standard_codedeploy_deployment_group_ruby" {
  app_name               = aws_codedeploy_app.iac_standard_codedeploy_app.name
  deployment_group_name  = "${var.project}-codedeploy-deployment-group-ruby-${var.env}"
  service_role_arn       = aws_iam_role.iac_standard_iam_role_codedeploy.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
## Setting for compute Server
#   autoscaling_groups     = [var.iac_standard_ruby_autoscale_group_name]
#   deployment_config_name = "CodeDeployDefault.AllAtOnce"

#   deployment_style {
#     deployment_option = "WITHOUT_TRAFFIC_CONTROL"
#     deployment_type   = "IN_PLACE"
#   }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }

  # You can configure the Load Balancer to use in a deployment.
  load_balancer_info {
    # Information about two target groups and how traffic routes during an Amazon ECS deployment.
    # An optional test traffic route can be specified.
    # https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_TargetGroupPairInfo.html
    target_group_pair_info {
      # The path used by a load balancer to route production traffic when an Amazon ECS deployment is complete.
      prod_traffic_route {
        listener_arns = [var.lb_listener_arn]
      }

      # One pair of target groups. One is associated with the original task set.
      # The second target is associated with the task set that serves traffic after the deployment completes.
      target_group {
        name = var.lb_target_group_name
      }

      target_group {
        name = var.alb_target_grp_name_green
      }
    }
  }
}

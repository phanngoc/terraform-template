#modules/application-layer/variables.tf
output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.web_app.name
}

output "iac_standard_ruby_autoscale_group_name" {
  value = aws_autoscaling_group.iac_standard_ruby_autoscale_group.name
}

output "alb_target_grp_blue_name" {
  value = aws_alb_target_group.alb_target_grp_blue.name
}

output "alb_target_grp_name_green" {
  value = aws_alb_target_group.alb_target_grp_green.name
}

output "lb_listener_arn" {
  value = aws_alb_listener.iac_standard_alb_ruby_listener.arn
}
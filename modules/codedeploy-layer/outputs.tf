#modules/codedeploy-layer/variables.tf

output "codedeploy_application_name" {
  value = aws_codedeploy_app.iac_standard_codedeploy_app.name
}

output "codedeploy_group_name" {
  value = aws_codedeploy_deployment_group.iac_standard_codedeploy_deployment_group_ruby.app_name
}

resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster
}

resource "aws_ecs_service" "web_app" {
  name            = "egg-web-service"
  iam_role        = aws_iam_role.ecs-service-role.name
  cluster         = aws_ecs_cluster.main.id
  task_definition = "${aws_ecs_task_definition.main.family}:${aws_ecs_task_definition.main.revision}"
  # task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.ecs_desired_capacity

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn  = aws_alb_target_group.alb_target_grp_blue.arn
    container_port    = 3000
    container_name    = "webapp"
  }

  lifecycle {
    ignore_changes = [load_balancer]
  }
}
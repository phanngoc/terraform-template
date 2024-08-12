# data "aws_ssm_parameter" "container_definitions" {
#   name = "./taskdef.yaml"
# }

data "template_file" "task_def" {
  template = file("${path.module}/taskdef.yaml.tpl")

  vars = {
    project = var.project
    account = var.account
    aws_ecr_repository = aws_ecr_repository.web-app.name
  }
}


resource "aws_ecs_task_definition" "main" {
  family                   = "task_definition_name"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["EC2"]

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.account}.dkr.ecr.us-east-2.amazonaws.com/${aws_ecr_repository.web-app.name}:latest",
    "name": "webapp",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region" : "us-east-2",
          "awslogs-group" : "egg_group",
          "awslogs-stream-prefix" : "egg_group_stream"
        }
    },
    "portMappings": [ 
      { 
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "folder",
        "value": "web"
      }
    ]
  }
]
DEFINITION
  # container_definitions = "${data.template_file.task_def.rendered}"
}
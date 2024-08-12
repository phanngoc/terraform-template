[
  {
    "image": "${account}.dkr.ecr.us-east-2.amazonaws.com/${aws_ecr_repository}:latest",
    "name": "webapp",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region" : "us-east-2",
          "awslogs-group" : "${project}_group",
          "awslogs-stream-prefix" : "${project}_group_stream"
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
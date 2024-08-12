data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                        = "ecs-launch-configuration-1"
  image_id                    = data.aws_ami.ecs_ami.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type = "standard"
    volume_size = 8
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.iac_standard_sg_ruby_instance.id]
  associate_public_ip_address = "true"
  key_name                    = "lab"
  user_data                   = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
EOF
}
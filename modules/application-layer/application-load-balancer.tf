# ALB for ruby
resource "aws_lb" "iac_standard_alb_ruby" {
  name               = "${var.project}-alb-ruby-${var.env}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.iac_standard_sg_ruby_alb.id]
  subnets            = var.iac_standard_subnet_public_id
  internal           = false

  idle_timeout = 60

  tags = {
    Name  = "${var.project}-alb-ruby-${var.env}"
    Type  = "ruby"
    Stage = var.env
  }
}

resource "aws_alb_listener" "iac_standard_alb_ruby_listener" {
  load_balancer_arn = aws_lb.iac_standard_alb_ruby.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_grp_blue.arn
  }
}

resource "aws_alb_target_group" "alb_target_grp_green" {
  name        = "${var.project}-alb-tgp-green-${var.env}"
  port     = 3000
  protocol = "HTTP"

  vpc_id = var.iac_standard_vpc_id

  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    timeout             = 5
  }
  
  deregistration_delay = 60

  tags = {
    Name  = "${var.project}-alb-tgp-${var.env}"
    Stage = var.env
  }
}

resource "aws_alb_target_group" "alb_target_grp_blue" {
  name     = "${var.project}-alb-ruby-tgp-${var.env}"
  port     = 3000
  protocol = "HTTP"

  vpc_id = var.iac_standard_vpc_id

  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    timeout             = 5
  }
  
  deregistration_delay = 60

  tags = {
    Name  = "${var.project}-alb-tgp-${var.env}"
    Stage = var.env
  }
}


# resource "aws_alb" "ecs-load-balancer" {
#   name                = "ecs-load-balancer"
#   security_groups     = ["${aws_security_group.test_public_sg.id}"]
#   subnets             = ["${aws_subnet.test_public_sn_01.id}", "${aws_subnet.test_public_sn_02.id}"]

#   tags {
#     Name = "ecs-load-balancer"
#   }
# }

# resource "aws_alb_target_group" "ecs-target-group" {
#   name                = "ecs-target-group"
#   port                = "80"
#   protocol            = "HTTP"
#   vpc_id              = "${aws_vpc.test_vpc.id}"

#   health_check {
#     healthy_threshold   = "5"
#     unhealthy_threshold = "2"
#     interval            = "30"
#     matcher             = "200"
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = "5"
#   }

#   tags {
#     Name = "ecs-target-group"
#   }
# }

# resource "aws_alb_listener" "http" {
#   load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#       target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
#       type             = "forward"
#   }
# }

# # resource "aws_alb_listener" "https" {
# #   load_balancer_arn = aws_lb.main.id
# #   port              = 443
# #   protocol          = "HTTPS"
 
# #   ssl_policy        = "ELBSecurityPolicy-2016-08"
# #   certificate_arn   = var.alb_tls_cert_arn
 
# #   default_action {
# #     target_group_arn = aws_alb_target_group.main.id
# #     type             = "forward"
# #   }
# # }

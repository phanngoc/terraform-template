#3. SG for ruby 
#3.1 ruby ELB
resource "aws_security_group" "iac_standard_sg_ruby_alb" {
  name        = "${var.project}-sg-alb-ruby-${var.env}"
  vpc_id      = var.iac_standard_vpc_id
  description = "Allow all out-traffic/Limit http, https in-traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    description = "Sun-HNI"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    description = "Sun-HNI"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project}-sg-alb-${var.env}"
    Stage = var.env
  }
}

#3.2 ruby Instance
resource "aws_security_group" "iac_standard_sg_ruby_instance" {
  name        = "${var.project}-sg-ec2-ruby-${var.env}"
  vpc_id      = var.iac_standard_vpc_id
  description = "Allow all out-traffic/Limit http, https, ssh in-traffic"

  ingress {
    from_port       = 22
    to_port         = 22
    description     = "allow bastion"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [var.iac_standard_sg_bastion_instance_id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    description     = "allow alb ruby"
    protocol        = "tcp"
    security_groups = [aws_security_group.iac_standard_sg_ruby_alb.id]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    description     = "allow alb ruby"
    protocol        = "tcp"
    security_groups = [aws_security_group.iac_standard_sg_ruby_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project}-sg-ec2-${var.env}"
    Stage = var.env
  }
}

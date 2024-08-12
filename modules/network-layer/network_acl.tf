resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.iac_standard_vpc.id
  subnet_ids = aws_subnet.iac_standard_subnet_public.*.id
  
  # egress {
  #   protocol   = "tcp"
  #   rule_no    = 200
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 22
  #   to_port    = 443
  # }

  # ingress {
  #   protocol   = "tcp"
  #   rule_no    = 100
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 80
  #   to_port    = 80
  # }

  tags = {
    Name  = "${var.project}-network-acl-${var.env}"
    Stage = var.env
  }
}

resource "aws_network_acl_rule" "ssh" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "http" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 400
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "net-out" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
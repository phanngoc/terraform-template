#1. NAT GATEWAY for private subnet
# resource "aws_eip" "iac_standard_nat_gateway_eip" {
#   vpc = true

#   tags = {
#     Name  = "${var.project}-eip-nat-gateway-${var.env}"
#     Stage = "${var.env}"
#   }
# }

# resource "aws_nat_gateway" "iac_standard_nat_gateway" {
#   allocation_id = "${aws_eip.iac_standard_nat_gateway_eip.id}"
#   subnet_id     = "${aws_subnet.iac_standard_subnet_public.*.id[0]}"

#   tags = {
#     Name  = "${var.project}-nat-gateway-${var.env}"
#     Stage = "${var.env}"
#   }
# }

#2. INTERNET GATEWAY for public subnet
resource "aws_internet_gateway" "iac_standard_internet_gateway" {
  vpc_id = aws_vpc.iac_standard_vpc.id

  tags = {
    Name  = "${var.project}-internet-gateway-${var.env}"
    Stage = var.env
  }
}

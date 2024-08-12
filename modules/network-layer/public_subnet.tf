#1.2 Public Subnet - Route Table
resource "aws_subnet" "iac_standard_subnet_public" {
  count                   = length(var.public_cidrs)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.iac_standard_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project}-subnet-public-${count.index + 1}-${var.env}"
    Stage = "${var.env}"
  }
}

resource "aws_route_table" "iac_standard_route_public" {
  vpc_id = aws_vpc.iac_standard_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_standard_internet_gateway.id
  }

  tags = {
    Name  = "${var.project}-route-public-${var.env}"
    Stage = "${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(aws_subnet.iac_standard_subnet_public)}"
  subnet_id      = "${aws_subnet.iac_standard_subnet_public.*.id[count.index]}"
  route_table_id = "${aws_route_table.iac_standard_route_public.id}"
}

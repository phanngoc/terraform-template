#modules/network-layer/variables.tf
output "iac_standard_vpc_id" {
  value = "${aws_vpc.iac_standard_vpc.id}"
}

output "iac_standard_subnet_private_id" {
  value = "${aws_subnet.iac_standard_subnet_private.*.id}"
}

# output "iac_standard_nat_gateway_public_ip" {
#   value = "${aws_nat_gateway.iac_standard_nat_gateway.public_ip}"
# }

output "iac_standard_subnet_public_id" {
  value = "${aws_subnet.iac_standard_subnet_public.*.id}"
}

output "iac_standard_internet_gateway_id" {
  value = "${aws_internet_gateway.iac_standard_internet_gateway.id}"
}

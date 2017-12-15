output "appsvpc_id" {
  value = "${aws_vpc.appsvpc.id}"
}

output "appsvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "appssubnet_cidr_block" {
  value = "${var.public_subnet_cidr_block}"
}

output "apps_natgw_id" {
  value = "${aws_nat_gateway.appsnatgw.id}"
}
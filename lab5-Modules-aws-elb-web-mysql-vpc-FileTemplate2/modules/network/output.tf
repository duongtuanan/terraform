output "vpc_id" {
  value		  = aws_vpc.vpc-srv-zone.id
  description = "VPC Id"
}
output "vpc_subnets" {
  value=aws_subnet.srv-subnet.*.id
}

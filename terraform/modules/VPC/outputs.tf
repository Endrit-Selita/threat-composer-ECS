output "vpc-ecs_id" {
  value = aws_vpc.vpc-ecs.id
}

output "vpc-ecs_cider_block" {
  value = aws_vpc.vpc-ecs.cidr_block
}
output "internet_gateway" {
  value = aws_internet_gateway.i-gateway.id
}

output "aws_availability_zones_names" {
  value = data.aws_availability_zones.az.names
}

output "public_subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnets" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "nat_gateway_id" {
  value = [aws_nat_gateway.nat-gw1.id, aws_nat_gateway.nat-gw2.id]
}

output "elastic_ip_id" {
  value = [aws_eip.eip1.id, aws_eip.eip2.id]
}


############### Create a VPC ###############
resource "aws_vpc" "vpc-ecs" {
  cidr_block = "10.10.0.0/16"
}

# Interet Gateway
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = aws_vpc.vpc-ecs.id

  tags = {
    Name = "gw"
  }
}

# availability Zone 
data "aws_availability_zones" "az" {
  state = "available"
}

# public subnet 1
resource "aws_subnet" "public1" {
  cidr_block              = "10.10.1.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[0]
}

 # Elastic IP for Nat gateway in public subnet 1
resource "aws_eip" "eip1" {
  domain   = "vpc"
}

# NAT gateway - public subnet 1
resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id
}

# Public subnet 2
resource "aws_subnet" "public2" {
  cidr_block              = "10.10.2.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[1]
}

 # Elastic IP for Nat gateway in public subnet 2
resource "aws_eip" "eip2" {
  domain   = "vpc"
}

# NAT gateway - public subnet 2
resource "aws_nat_gateway" "nat-gw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id
}

# private subnet 1 in AZ1
resource "aws_subnet" "private1" {
  cidr_block              = "10.10.3.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.az.names[0]
}

# private subnet 2 in AZ2
resource "aws_subnet" "private2" {
  cidr_block              = "10.10.4.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.az.names[1]
}

# route table internet gateway
resource "aws_route_table" "ig_rt_public" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gateway.id
  }
}

#public subnet 1 association to internet gateway route table
resource "aws_route_table_association" "pubsub1-igr" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.ig_rt_public.id
}

#public subnet 2 association to internet gateway route table
resource "aws_route_table_association" "pubsub2-igr" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.ig_rt_public.id
}

# route table NAT Gateway in public subnet 1
resource "aws_route_table" "ng_rt_ecs_1" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw1.id
  }
}

# private subnet 1 association to NAT Gateway route table 1
resource "aws_route_table_association" "prisub1-ngr" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.ng_rt_ecs_1.id
}

# route table NAT Gateway in public subnet 2
resource "aws_route_table" "ng_rt_ecs_2" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw2.id
  }
}

# private subnet 2 association to NAT Gateway route table 2
resource "aws_route_table_association" "prisub2-ngr" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.ng_rt_ecs_2.id
}

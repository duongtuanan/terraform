
# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# ----------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {}


# ----------------------------------------------------------------------------------------------------------------------
# Create a VPC to launch our instances into:
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "vpc-srv-zone" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = "vpc-srv-zone"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create an internet gateway to give our subnet access to the outside world:
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "gateway-srv-zone" {
  vpc_id = "${aws_vpc.vpc-srv-zone.id}"
  tags = {
    Name = "internet-gateway-vpc-srv-zone"
  }
}
# ----------------------------------------------------------------------------------------------------------------------
# Grant the VPC internet access on its main route table:
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_route" "route-srv-zone" {
  route_table_id         = "${aws_vpc.vpc-srv-zone.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gateway-srv-zone.id}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Create subnets in each availability zone to launch our instances into, each with address blocks within the VPC:
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "srv-subnet" {
  vpc_id					= "${aws_vpc.vpc-srv-zone.id}"
  count 					= "${length(data.aws_availability_zones.available.names)}"
 
  cidr_block 				= "${var.cidr_subnet}.${20+count.index}.0/24"
  availability_zone 		= "${data.aws_availability_zones.available.names[count.index]}"
  
  map_public_ip_on_launch 	= true
  tags = {
    Name = "srv-subnet "
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create a default security group in the VPC which our instances will belong to:
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "srv-zone-default-security-group" {
  name        	= "default-srv-zone-security-group"
  description 	= "Default security group for srv-zone"
  vpc_id      	= "${aws_vpc.vpc-srv-zone.id}"

  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-srv-zone-security-group"
  }
}

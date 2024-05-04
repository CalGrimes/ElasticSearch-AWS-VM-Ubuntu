## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "aws_vpc" "ELK" {
  cidr_block = var.VPC-CIDR
  tags = {
    Name = "ELKVPC"
    Group = "ELK"
  }
}

resource "aws_subnet" "ELK" {
  vpc_id                  = aws_vpc.ELK.id
  cidr_block              = var.ELKSubnet-CIDR
  map_public_ip_on_launch = true
  tags = {
    Name = "ELKSNET"
    Group = "ELK"
  }
}

resource "aws_internet_gateway" "ELKIG" {
  vpc_id = aws_vpc.ELK.id
  tags = {
    Name = "ELKIG"
    Group = "ELK"
  }
}

resource "aws_route_table" "ELKRT" {
  vpc_id = aws_vpc.ELK.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ELKIG.id
  }
  tags = {
    Name = "ELKRT"
    Group = "ELK"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "ELKRTA" {
  subnet_id      = aws_subnet.ELK.id
  route_table_id = aws_route_table.ELKRT.id
}

resource "aws_network_interface" "ELK" {
  subnet_id       = aws_subnet.ELK.id
  private_ips     = ["10.1.20.5"]
  security_groups = [aws_security_group.ELKSecurityGroup.id]

  tags = {
    Name = "ELKNetworkInterface"
  }
}
## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "aws_security_group" "ELKSecurityGroup" {
  vpc_id = aws_vpc.ELK.id
  name   = "ELKSecurityGroup"

  tags = {
    Name = "ELKSecurityGroup"
    Group = "ELK"
  }

}

resource "aws_vpc_security_group_ingress_rule" "shh_my_ip" {
  security_group_id = aws_security_group.ELKSecurityGroup.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4 = concat(var.my_ip, "/32")
  description = "Allow SSH from my IP"

  tags = {
    name = "ssh_my_ip"
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "es_my_ip" {
  security_group_id = aws_security_group.ELKSecurityGroup.id
  from_port         = var.ESDataPort
  to_port           = var.ESDataPort
  ip_protocol       = "tcp"
  cidr_ipv4 = concat(var.my_ip, "/32")
  description = "Allow Elasticsearch from my IP"

  tags = {
    name = "es_my_ip"
  }
  
}

resource "aws_vpc_security_group_egress_rule" "es_all" {
  security_group_id = aws_security_group.ELKSecurityGroup.id
  ip_protocol       = "-1"
  cidr_ipv4        = "0.0.0.0/0"
  description = "Allow all outbound traffic"

  tags = {
    name = "es_all"
  }
}
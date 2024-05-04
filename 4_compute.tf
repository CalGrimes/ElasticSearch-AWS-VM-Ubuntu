## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "ELK" {
  template = file("./scripts/elk.sh")

  vars = {
    elasticsearch_download_url      = var.elasticsearch_download_url
    kibana_download_url             = var.kibana_download_url
    logstash_download_url           = var.logstash_download_url
    elasticsearch_download_version  = var.elasticsearch_download_version
    kibana_download_version         = var.kibana_download_version
    logstash_download_version       = var.logstash_download_version
    KibanaPort                      = var.KibanaPort
    ESDataPort                      = var.ESDataPort
    ssh_public_key                  = tls_private_key.public_private_key_pair.public_key_openssh
  }

}

resource "aws_key_pair" "ELK" {
  key_name   = "ELK"
  public_key = tls_private_key.public_private_key_pair.public_key_openssh
}

resource "local_file" "Public_Key" {
  content  = aws_key_pair.ELK.public_key
  filename = "${path.module}/ELK_public_key.pem"
}

resource "local_file" "Private_Key" {
  content  = tls_private_key.public_private_key_pair.private_key_pem
  filename = "${path.module}/ELK_private_key.pem"
}

resource "aws_instance" "ELK" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ELK.key_name
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.ELK.id
  }
  user_data                   = base64encode("${data.template_file.ELK.rendered}")
  tags = {
    Name = "ELKVM"
    Group = "ELK"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
    volume_type = "gp2"
    delete_on_termination = true
  }
}
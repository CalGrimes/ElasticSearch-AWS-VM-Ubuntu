## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "region" {}
variable "vpc_id" {}
variable "my_ip" {}

variable "ami" {
  default = "ami-09627c82937ccdd6d" # Ubtuntu 22.04
}

variable "instance_type" {
  default = "t2.medium"
}



variable "availability_domain_name" {
  default = ""
}
variable "availability_domain_number" {
  default = 0
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "2.2"
}

variable "ssh_public_key" {
  default = ""
}

variable "VPC-CIDR" {
  default = "10.1.0.0/16"
}

variable "ELKSubnet-CIDR" {
  default = "10.1.20.0/24"
}

variable "elasticsearch_download_url" {
  default = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch"
}

variable "elasticsearch_download_version" {
  default = "7.16.3"
}

variable "kibana_download_url" {
  default = "https://artifacts.elastic.co/downloads/kibana/kibana"
}

variable "kibana_download_version" {
  default = "7.16.3"
}

variable "logstash_download_url" {
  default = "https://artifacts.elastic.co/downloads/logstash/logstash"
}

variable "logstash_download_version" {
  default = "7.16.3"
}

variable "KibanaPort" {
  default = "5601"
}

variable "ESDataPort" {
  default = "9200"
}


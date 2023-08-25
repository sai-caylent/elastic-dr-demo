provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}
terraform {
  required_providers {
    aws = {
      version = ">= 4.66"
      source  = "hashicorp/aws"
    }
  }
}
data "aws_availability_zones" "available" {}

locals {
  name        = "demo-${basename(path.cwd)}"
  region      = "us-east-2"
  ec2_linux   = "ami-0d3183af565a0a95d"
  ec2_windows = "ami-0007e91afefcd1257"
  ec2_ubuntu  = "ami-024e6efaf93d85776"
  vpc_cidr    = "172.25.0.0/24"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

  user_data = <<-EOT
  #!/bin/bash
  yum update -y
  yum install httpd -y
  sleep 10
  echo "<html><h1>Hello Word from $(hostname -f)</h1></html>" >> /var/www/html/index.html
  sleep 5
  systemctl start httpd
  systemctl enable httpd
  EOT

  tags = {
    site      = local.name
    terraform = "yes"
    owner     = "sai"
    temporary = "yes"
    client    = "edmentum"
    project   = "cloudendure to elastic DR"
  }
}

locals {
  name   = "demo-${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr    = "172.26.0.0/24"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  ec2_linux   = "ami-0baa3f62c0ca83387"
  ec2_windows = "ami-0007e91afefcd1257"

  user_data = <<-EOT
  #!/bin/bash
  yum install nc -y
  nc -l 1500
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

provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}
module "iam_assumable_role_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  role_name = "recovery_instance_role"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    # "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryEc2InstancePolicy",
    "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryRecoveryInstancePolicy"
  ]

}
data "aws_caller_identity" "current" {}


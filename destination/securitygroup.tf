module "security-group" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "5.1.0"
  for_each                 = local.security_groups
  vpc_id                   = module.vpc.vpc_id
  name                     = each.key
  description              = "EDR Demo SG"
  use_name_prefix          = false
  ingress_with_cidr_blocks = each.value.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = each.value.egress_with_cidr_blocks

}

locals {
  security_groups = {
    ec2_linux = {
      ingress_with_cidr_blocks = [
        {
          description = "SSH Ingress"
          from_port   = 22
          to_port     = 22
          protocol    = "TCP"
          cidr_blocks = "0.0.0.0/0"

        },
        {
          description = "Allow http Traffic"
          from_port   = 80
          to_port     = 80
          protocol    = "TCP"
          cidr_blocks = "0.0.0.0/0"
        },
        {
          description = "Allow Any internal Traffic"
          from_port   = 0
          to_port     = 0
          protocol    = -1
          cidr_blocks = module.vpc.vpc_cidr_block

        },
        {
          description = "Allow replication Traffic"
          from_port   = 1500
          to_port     = 1500
          protocol    = "TCP"
          cidr_blocks = "0.0.0.0/0"
        },
        {
          description = "ICMP"
          from_port   = -1
          to_port     = -1
          protocol    = "ICMP"
          cidr_blocks = "0.0.0.0/0"

        }
      ]
      egress_with_cidr_blocks = [

        {
          description = "Allow all egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
    }
    ec2_windows = {
      ingress_with_cidr_blocks = [
        {
          description = "RDP"
          from_port   = 3389
          to_port     = 3389
          protocol    = "TCP"
          cidr_blocks = "216.73.178.66/32"

        },
        {
          description = "Allow http Traffic"
          from_port   = 80
          to_port     = 80
          protocol    = "TCP"
          cidr_blocks = "216.73.178.66/32"
        },
        {
          description = "Allow Any internal Traffic"
          from_port   = 0
          to_port     = 0
          protocol    = -1
          cidr_blocks = module.vpc.vpc_cidr_block

        },
        {
          description = "ICMP"
          from_port   = -1
          to_port     = -1
          protocol    = "ICMP"
          cidr_blocks = "0.0.0.0/0"

        },
        {
          description = "Allow Any from ohio Traffic"
          from_port   = 0
          to_port     = 0
          protocol    = -1
          cidr_blocks = "10.31.0.0/24"

        },
      ]
      egress_with_cidr_blocks = [
        {
          description = "Allow all egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
    }
  }
}

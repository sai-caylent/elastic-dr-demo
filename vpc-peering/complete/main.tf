module "vpc_peering_cross_account" {
  source = "../../module/terraform-aws-vpc-peering"

  providers = {
    aws.accepter = aws.accepter
  }

  requester_vpc_id                          = data.terraform_remote_state.requester.outputs.vpc
  requester_allow_remote_vpc_dns_resolution = true

  accepter_vpc_id                          = data.terraform_remote_state.accepter.outputs.vpc
  accepter_allow_remote_vpc_dns_resolution = true

  tags = var.tags
}

data "terraform_remote_state" "requester" {
  backend = "local"

  config = {
    path = "../../source/terraform.tfstate"
  }
}

data "terraform_remote_state" "accepter" {
  backend = "local"

  config = {
    path = "../../destination/terraform.tfstate"
  }
}

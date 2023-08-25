locals {
  requester_vpc_id                 = data.aws_vpc.requester.id
  requester_cidr_block             = data.aws_vpc.requester.cidr_block
  accepter_vpc_id                  = data.aws_vpc.accepter.id
  accepter_cidr_block              = data.aws_vpc.accepter.cidr_block
  active_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id
}

data "aws_vpc" "requester" {
  id = var.requester_vpc_id
}

data "aws_vpc" "accepter" {
  provider = aws.accepter
  id       = var.accepter_vpc_id
}

data "aws_caller_identity" "peer" {
  provider = aws.accepter
}

data "aws_region" "peer" {
  provider = aws.accepter
}

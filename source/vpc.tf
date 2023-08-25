module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name    = "demo-source-vpc"
  cidr    = local.vpc_cidr

  azs = local.azs

  public_subnets       = ["172.25.0.0/26", "172.25.0.64/26"]
  private_subnets      = ["172.25.0.128/26", "172.25.0.192/26"]
  private_subnet_names = ["demo-priv-subnet-us-east-2a", "demo-priv-subnet-us-east-2b"]
  public_subnet_names  = ["demo-pub-subnet-us-east-2a", "demo-pub-subnet-us-east-2b"]
  enable_nat_gateway   = true
}

data "aws_caller_identity" "current" {}


# data "terraform_remote_state" "canada" {
#   backend = "local"

#   config = {
#     path = "../site-canada/terraform.tfstate"
#   }
# }

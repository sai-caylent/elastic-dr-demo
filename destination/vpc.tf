module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name    = "demo-dr-vpc"
  cidr    = local.vpc_cidr

  azs = local.azs

  public_subnets       = ["172.26.0.0/26", "172.26.0.64/26"]
  private_subnets      = ["172.26.0.128/26", "172.26.0.192/26"]
  private_subnet_names = ["demo-priv-staging", "demo-priv-recovery"]
  public_subnet_names  = ["demo-pub-staging", "demo-pub-recovery"]
  enable_nat_gateway   = true
}
data "aws_availability_zones" "available" {}


# data "terraform_remote_state" "ohio" {
#   backend = "local"

#   config = {
#     path = "../site-ohio/terraform.tfstate"
#   }
# }


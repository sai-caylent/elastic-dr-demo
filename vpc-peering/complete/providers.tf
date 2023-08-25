provider "aws" {
  region = "us-east-2"


}

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"


}

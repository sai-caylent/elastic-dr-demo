terraform {
  required_version = ">= 1.2.0, < 2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.49.0"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.6.6"
}


provider "aws" {
  region = "sa-east-1"
}

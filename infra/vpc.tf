module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  name           = "minecraft_vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

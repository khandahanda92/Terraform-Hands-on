#Custom VPC for my Project 
module "levelup-vpc" {
  source = "terraform-aws-modules/vpc/aws" # from the registry from terrafrom.io

  name = "vpc-${var.ENVIRONMENT}"
  cidr = "10.0.0.0/16"

  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"] # us-east-2a , b &c
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.ENVIRONMENT
  }
}

#Output Specific to Custom VPC
output "my_vpc_id" {
  description = "VPC ID"
  value       = module.levelup-vpc.vpc_id # this will return the single return value 
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.levelup-vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.levelup-vpc.public_subnets
}


# private and public subnet will return the list    

# Here we are using the env and the region as a varaible so create the variable.tf file abd define  it 
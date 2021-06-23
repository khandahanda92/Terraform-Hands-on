# Create Resource for Development Environment

module "dev-vpc" {  # 1st module 
    source      = "../modules/VPC"

    ENVIRONMENT = var.Env
    AWS_REGION  = var.AWS_REGION
}

module "dev-instances" {  # 2nd module will define the ec2 instances 
    source          = "../modules/instance"

    ENVIRONMENT     = var.Env
    AWS_REGION      = var.AWS_REGION 
    VPC_ID          = module.dev-vpc.my_vpc_id
    PUBLIC_SUBNETS  = module.dev-vpc.public_subnets # define the module and the variable 
}

provider "aws" {
  region = var.AWS_REGION
}


# Check the variable.tf in modules to check the variables need to be defined here 
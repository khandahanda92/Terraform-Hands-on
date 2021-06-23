## Here we will include the module from the git source code 

provider "aws" {
  region     = var.AWS_REGION
}

module "ec2_cluster" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"

    name            = "my-cluster"
    ami             = "ami-05692172625678b4e"
    instance_type   = "t2.micro"
    subnet_id       = "subnet-6eb70205"
    instance_count  = var.environment == "Production" ? 2 : 1 # It mean if env in production then we need to spin up
    # two instances othereise spin up one instance 


    tags = {
    Terraform       = "true"
    Environment     = var.environment
    }
}
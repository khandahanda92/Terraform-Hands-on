## here we will mention the code which will be usefull to create the ec2 instance with the help of source code from github 

module "ec2_cluster" { # name of the module 
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git" # from the git hub 

    name    = "my-cluster"
    ami     = "ami-0f40c8f97004632f9" # ami for the us -east 1 
    instance_type          = "t2.micro"
    subnet_id   = "subnet-0f51c63e" # pic from the default subnet us-east-1e

    tags = {
    Terraform   = "true"
    Environment = "dev"
    }
}

# Here i am consuming the modules from the github repository and now we have to create the provider.tf file 
# Madantory , otherwise we will get errors 
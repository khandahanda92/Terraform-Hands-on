module "dev-qa-vpc"{
    source                          = "../../custom_vpc" # is the source of the modules 

    vpcname                         = "dev02-qa-vpc"
    cidr                            = "10.0.1.0/24"
    enable_dns_support              = "true"
    enable_classiclink              = "false"
    enable_classiclink_dns_support  = "false"
    enable_ipv6                     = "false"
    vpcenvironment                  = "Development-QA-Engineering"
    AWS_REGION                      = "us-east-1"

}

## Here we are defining the values we want to use for the modules 
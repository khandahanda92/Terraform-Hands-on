module "dev-vpc"{
    source                          = "../../Custom VPC" # defining the module name 

    vpcname                         = "dev01-vpc"
    cidr                            = "10.0.2.0/24"
    enable_dns_support              = "true"
    enable_classiclink              = "false"
    enable_classiclink_dns_support  = "false"
    enable_ipv6                     = "true"
    vpcenvironment                  = "Development-Engineering" 

}

# here it will take the region from the default value which is defined in the variable file 
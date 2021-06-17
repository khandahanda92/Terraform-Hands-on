## Create security group on the basis of region filter 
data "aws_ip_ranges" "us_east_ip_range" { # aws_ip_range is variable 
regions = ["us-east-1","us-east-2"] # definning on which region we want the ip filter
services = ["ec2"] # on which services we want this ip filter 

# Datasource for aws_ip_ranges for us_east1 & 2 

}

resource "aws_security_group" "sg-custom_us_east" { # security group name 
  name  = "sg-custom_us_east"
    
    ingress {
      from_port = "443" # From which port you want to accept the traffic 
      to_port = "443" # to send on which port 
      protocol = "tcp"
      cidr_blocks = data.aws_ip_ranges.us_east_ip_range.cidr_blocks
  }

   tags = {
        CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date # date for the security group 
        SyncToken = data.aws_ip_ranges.us_east_ip_range.sync_token
    }
}

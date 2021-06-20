## Create AWS VPC

resource "aws_vpc" "levelup_vpc" { # name of vpc 
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default" 
   # More than one instance can be spin on more than one hardware  otherwise it will spin on sperate hardware & costly 
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  # create hostname and dns of your internal instance name 
  enable_classiclink   = "false"

  tags = {
    Name = "levelup_vpc"
  }
}

#  3 Public Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-public-1" { # name of subnet 
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"  
  # means the instance is launced in this vpc by deafult the public ip is associated 
  availability_zone       = "us-east-2a"

  tags = {
    Name = "levelupvpc-public-1"
  }
}

resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24" # CIDR block should be different 
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "levelupvpc-public-2"
  }
}

resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "levelupvpc-public-3"
  }
}


#  3  Private Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-private-1" { # name of subnet 
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"  
  # means the instance is launced in this vpc by no  the public ip is associated 
  availability_zone       = "us-east-2a"

  tags = {
    Name = "levelupvpc-private-1"
  }
}

resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.5.0/24" # CIDR block should be different 
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "levelupvpc-private-2"
  }
}

resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
    Name = "levelupvpc-private-3"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" { # gateway name 
  vpc_id = aws_vpc.levelupvpc.id
# Defining the VPN id on which its applicable 
  tags = {
    Name = "levelup-gw"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "levelup-public" { # name of route table 
  vpc_id = aws_vpc.levelupvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id
# Means all the traffic which my instance which is using this custom vpc wants to acess and can acess traffic 
  }

  tags = {
    Name = "levelup-public-1"
  }
} 

# now its time to difine the route associations 
resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
#  levelup-public-1 - This is the name of your  Fist public subnet we are defining the routing table  
  route_table_id = aws_route_table.levelup-public.id  # Its using this route table 
}

## Defining same for the other two as well 
resource "aws_route_table_association" "levelup-public-2-a" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-3-a" {
  subnet_id      = aws_subnet.levelupvpc-public-3.id
  route_table_id = aws_route_table.levelup-public.id
}
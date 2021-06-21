## In this file we will create the configuration of security groups which will use the vpc 

#Security Group for levelupvpc
resource "aws_security_group" "allow-levelup-ssh" { # name of my security group 
  vpc_id      = aws_vpc.levelupvpc.id  # name of vpc so that this security group will refer the vpc which was created 
  name        = "allow-levelup-ssh"
  description = "security group that allows ssh connection"

  egress {  # egress rule is for outbound traffic 
    from_port   = 0 # all 
    to_port     = 0 # all 
    protocol    = "-1" # all protocol 
    cidr_blocks = ["0.0.0.0/0"]  # traffic allowed to all ips 
  }

  ingress {  # for inbound rule i am accepting the traffic from 22 to 22 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # all ips , you can also define the list or define the ip on local machine and the box 
  }
  
  tags = {
    Name = "allow-levelup-ssh"
  }
}

# This above security group we have used inside the instance 

#Security Group for MariaDB
resource "aws_security_group" "allow-mariadb" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "allow-mariadb"
  description = "security group for Maria DB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.allow-levelup-ssh.id]
    # Defining the security group of the aws instances which would be alowed to access the mariadb
    # As we are going to spin the instance with aws_security_group so we are definning it here 
    ## Replacing the cidr in this case 
  }
  
  tags = {
    Name = "allow-mariadb"
  }
}
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


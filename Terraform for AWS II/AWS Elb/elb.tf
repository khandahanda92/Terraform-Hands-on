#AWS ELB Configuration
resource "aws_elb" "levelup-elb" {
  name            = "levelup-elb" # name of the elb 
  subnets         = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]
  # we need two public regions to spin up the elb 
  security_groups = [aws_security_group.levelup-elb-securitygroup.id]
  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
    # it means to will  send /receive traffic on port 80 http means instance and the lb listen the traffic 
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
# it means after each 30 seconds this health check will triger on port 80 by http portocol 
# Timeout of heaktch will be 3 sec and will mark the healthy node after two consecutive sucess and mark it 
# unhealthy after two consecutive failures 
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
#With Connection Draining feature enabled, if an EC2 backend instance fails health checks the Elastic Load Balancer will not send any new requests to the unhealthy instance. However, it will still allow existing (in-flight) requests to complete for the duration of the configured timeout.
  tags = {
    Name = "levelup-elb"
  }
}

#Security group for AWS ELB
resource "aws_security_group" "levelup-elb-securitygroup" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "levelup-elb-sg"
  description = "security group for Elastic Load Balancer"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all the protocal 
    cidr_blocks = ["0.0.0.0/0"]  # all the ips 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # here we are only accepting and sending the trrafic on port 80 on all the ips 
  }

  tags = {
    Name = "levelup-elb-sg"
  }
}

#Security group for the Instances , so instances this particular ELB manages , this security group will work in these instances 
resource "aws_security_group" "levelup-instance" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "levelup-instance"
  description = "security group for instances"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {  # This is for the ssh connections on the instances 
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # this is for the connection from the ELB , elb will hit on 80 
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.levelup-elb-securitygroup.id] # security group of the elb 
    # so that only elb can make the connections to the port 80 
  }

  tags = {
    Name = "levelup-instance"
  }
}
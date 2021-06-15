resource "aws_instance" "firstmachine" {
  ami           = "lookup(var.AMIS, var.AWS_REGION)"

  ## Once the code reach at this location lookup will search the value for aws region inside 
  ## The varibale aws amis , if the value is us east 2 it will search for the ami value from the variable file 
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstance"
  }

  security_groups = "${var.Security_Group}"
  # define the list of security group of instances in aws
}


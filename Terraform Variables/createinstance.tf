resource "aws_instance" "firstmachine" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstance"
  }

  security_groups = "${var.Security_Group}"
  # define the list of security group of instances in aws
}


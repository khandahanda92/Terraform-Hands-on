data "aws_availability_zones" "available" {}
## This will fetch all the availablity zones which are available in AWS

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[0]

  # This will fetch the availablity zone and put in this variable -available
  # [1] - aws have four availablity zones a, b, c and d - it will choose for index 1 

  tags = {
    Name = "custom_instance"
  }
}
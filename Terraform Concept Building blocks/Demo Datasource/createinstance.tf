data "aws_availability_zones" "available" {}

## This will fetch all the availablity zones which are available in AWS


data "aws_ami" "latest_ubuntu" {  ## To choose AMi 
  most_recent = true
  owners = ["099720109477"]

  ## owner for ubuntu you can find on aws finding a linux ami doc

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = data.aws_ami.latest_ubuntu.id # Defining the AMI 
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[1]
   # This will fetch the availablity zone and put in this variable -available
  # [1] - aws have four availablity zones a, b, c and d - it will choose for index 1 


  provisioner "local-exec" {
    command = "echo aws_instance.MyFirstInstnace.private_ip >> my_private_ip.txt"
    # Here we are running this to get the private ip 

  }

 
  tags = {
    Name = "custom_instance"
  }

output "public_ip" {
    value = aws_instance.MyFirstInstnace.public_ip # This wil desplay the public ip of your machine on console 
  }
}

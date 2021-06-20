
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  user_data = file("installapache.sh") # defining the file name for the script 

# Here we are removed the subnet because we ae going to use the default subnet 
  tags = {
    Name = "custom_instance"
  }

}
# Also printing the public ip of the instance 
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}


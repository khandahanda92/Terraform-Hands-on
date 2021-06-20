
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.allow-levelup-ssh.id] # define the name of the security 
  subnet_id = aws_subnet.levelupvpc-public-2.id
  # need to define the public subnet of my vpc , need to define in whcih subnet we need to create the instance 
  # otherwise the defaut subnet is taken 
  # copy the subnet name from vpc.tf file 

  tags = {
    Name = "custom_instance"
  }

}

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name      = aws_key_pair.levelup_key.key_name
  
  iam_instance_profile = aws_iam_instance_profile.s3-levelupbucket-role-instanceprofile.name
 # we are defining this so that this instance can identify this particular role  sp we have defined the key iam_profile 
    tags = {
    Name = "custom_instance"
  }

}
# Also printing the public ip of the instance 
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}


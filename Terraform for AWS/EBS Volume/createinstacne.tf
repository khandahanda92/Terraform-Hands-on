
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

# Here we are removed the subnet because we ae going to use the default subnet 
  tags = {
    Name = "custom_instance"
  }

}

#EBS resource Creation
resource "aws_ebs_volume" "ebs-volume-1" { # name of EBS volume 
  availability_zone = "us-east-2b"# defining the region 
  size              = 50  # size in gb 
  type              = "gp2"

  tags = {
    Name = "Secondary Volume Disk"
  }
}

#Atatch EBS volume with AWS Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id  
  instance_id = aws_instance.MyFirstInstnace.id
}

## Attching this volume with the instance 

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
    ##  Here the key name is levelup_key This  variable is defined in varible file 
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  tags = {
    Name = "custom_instance"
  }

  provisioner "file" {
      source = "installNginx.sh"
      destination = "/tmp/installNginx.sh"
      # On aws machine this file will be uploaded at /tmp location 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",  # Remove the spurious CR characters.
      "sudo /tmp/installNginx.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip) # This is the function name wto accept keys 
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY) # This is also declared in the varibale file 
  }
}

# Public key is defined in the resource section which will upload over to the AWS and private key will be 
# on the machine which will be excecuting the scripts 

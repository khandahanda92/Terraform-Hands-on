resource "aws_instance" "firstmachine" {
  count         = 3 
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstance-${count.index}"
  }
}

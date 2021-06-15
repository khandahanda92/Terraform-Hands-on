provider "aws" {
    access_key = ""
    secret_key = " "
    region     = "us-east-2"
}
resource "aws_instance" "first instance" {
  ami           = "ami-05d72852800cbf29e"
  instance_type = "t2.micro"
}
provider "aws" {
    access_key = "AKIASYJBFX4BXRODSWK4"
    secret_key = "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"
    region     = "us-east-2"
}
resource "aws_instance" "firstmachine" {
  ami           = "ami-05d72852800cbf29e"
  instance_type = "t2.micro"
}
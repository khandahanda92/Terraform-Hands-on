terraform {
  backend "s3" {
      bucket = "tf-state92" # bucket name 
      key = "devlopment/terraform_state" # key to seperate out the project 
      region = "us-east-2"
  }
}  
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
default = "us-east-2"
}

variable "Security_Group"{
    type = list
    default = ["sg-24076", "sg-90890", "sg-456789"]
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0f40c8f97004632f9"
        us-east-2 = "ami-05692172625678b4e"
        us-west-2 = "ami-0352d5a37fb4f603f"
        us-west-1 = "ami-0f40c8f97004632f9"
    }
}

variable "PATH_TO_PRIVATE_KEY" { # PAth of private key on the local box 
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
   # Path of keys and are in the same directory , then path will be etc/levelup_key_pub
}

variable "INSTANCE_USERNAME" { # username which will make the ssh connection 
  default = "ubuntu"
}
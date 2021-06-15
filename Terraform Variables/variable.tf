variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
default = "us-east-2"
}

variable "Security_Group"{
    type = list
    default = ["sg-24076", "sg-90890", "sg-456789"]
    ## These are the default security groups inside the varibale file that we need to use while creating the instance
}
variable "AWS_REGION" {
    type        = string
    default     = "us-east-2"
}

variable "environment" {
    type        = string
    default     = "Devlopment"  

}

## As per the condition which we set in create instacne file wif the env is prod 2 instances wil be launched 
## IF it not then only one instance , observer my changing the environment value 
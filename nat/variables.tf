
variable "key_name" {
    type = string
    default = "ec2key"
  
}

variable "base_path" {

    default = "/home/knoldus/terraform_practice/nat"
  
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}
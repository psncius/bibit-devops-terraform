variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-southeast-1"
}

variable "ami" {
  description = "AMI for EC2"
  default = "ami-01ed306a12b7d1c96"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/c/Users/support/.ssh/id_rsa.pub"
}
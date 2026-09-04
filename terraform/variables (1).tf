variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair (create this in AWS console first)"
  type        = string
}

variable "my_ip" {
  description = "Your local IP in CIDR form, e.g. 1.2.3.4/32 (get it from whatismyip.com)"
  type        = string
}

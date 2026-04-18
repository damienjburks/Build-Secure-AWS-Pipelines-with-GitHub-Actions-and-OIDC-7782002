# Input Variables
# These variables allow customization of the deployment without modifying the main configuration

# AWS Region Variable
# Specifies which AWS region to deploy resources into
# Default is us-east-1 (N. Virginia) which is commonly used and has all services available
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

# EC2 Instance Type Variable
# Defines the size/capacity of the EC2 instance
# t2.micro is free tier eligible and sufficient for a simple web server demonstration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

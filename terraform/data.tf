# ============================================================================
# Data Sources
# Data sources query AWS for existing information rather than creating resources
# ============================================================================

# Data source for current AWS caller identity
# Retrieves information about the AWS identity making the Terraform calls
# Used to determine if deployment is using IAM User or IAM Role (OIDC)
data "aws_caller_identity" "current" {}

# Data source for available AWS availability zones
# Retrieves a list of availability zones in the current region
# Used to dynamically select an AZ for the subnet without hardcoding
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source for Amazon Linux 2023 AMI
# Automatically finds the latest Amazon Linux 2023 AMI ID
# This ensures we always use the most up-to-date image without manual updates
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"] # Only search AMIs owned by Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # Match Amazon Linux 2023 AMI naming pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"] # Hardware Virtual Machine (required for modern instance types)
  }
}
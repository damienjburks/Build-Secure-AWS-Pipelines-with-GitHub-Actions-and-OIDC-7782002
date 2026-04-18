# Terraform Configuration Block
# Specifies the minimum Terraform version and required providers
# This ensures compatibility and prevents issues with older Terraform versions
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use AWS provider version 5.x (allows minor and patch updates)
    }
  }
}

# AWS Provider Configuration
# Configures authentication and default settings for AWS resources
# Authentication is handled via environment variables set by GitHub Actions OIDC
provider "aws" {
  region = var.aws_region # Deploy resources to the specified AWS region

  # Default tags applied to all resources created by this configuration
  # These tags help with resource organization, cost tracking, and management
  default_tags {
    tags = {
      Project     = "Vervium-AWS-Deployment-Pipeline" # Identifies resources belonging to this project
      ManagedBy   = "Terraform"                     # Indicates infrastructure is managed as code
      Environment = "Education"                     # Marks this as an educational/learning environment
    }
  }
}

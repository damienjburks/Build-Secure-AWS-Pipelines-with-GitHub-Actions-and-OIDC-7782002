# ============================================================================
# Terraform Backend Configuration - S3 Remote State
# ============================================================================
# This configuration stores Terraform state in an S3 bucket instead of locally
# 
# Benefits of S3 backend:
# - Centralized state storage accessible by team members
# - State locking via DynamoDB prevents concurrent modifications
# - Versioning enabled for state file history and recovery
# - Encryption at rest for sensitive data protection
# - Better suited for CI/CD pipelines and team collaboration
#
# Prerequisites:
# 1. Create an S3 bucket for state storage
# 2. Create a DynamoDB table for state locking (optional but recommended)
# 3. Ensure IAM permissions allow access to S3 and DynamoDB
#
# To create the required resources:
# 
# S3 Bucket:
#   aws s3api create-bucket \
#     --bucket your-terraform-state-bucket \
#     --region us-east-1
#
#   aws s3api put-bucket-versioning \
#     --bucket your-terraform-state-bucket \
#     --versioning-configuration Status=Enabled
#
#   aws s3api put-bucket-encryption \
#     --bucket your-terraform-state-bucket \
#     --server-side-encryption-configuration '{
#       "Rules": [{
#         "ApplyServerSideEncryptionByDefault": {
#           "SSEAlgorithm": "AES256"
#         }
#       }]
#     }'
#
# DynamoDB Table (for state locking):
#   aws dynamodb create-table \
#     --table-name terraform-state-lock \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST \
#     --region us-east-1
#
# ============================================================================

terraform {
  backend "s3" {
    # S3 bucket name
    bucket = "terraform-state-379755567541-us-east-1-an"
    
    # Path within the bucket where the state file will be stored
    # Using a descriptive path helps organize multiple projects
    key = "linkedin-learning-oidc/terraform.tfstate"
    
    # AWS region where the S3 bucket is located
    region = "us-east-1"
    
    # Enable encryption at rest for the state file
    # Protects sensitive data like passwords and API keys
    encrypt = true
  }
}

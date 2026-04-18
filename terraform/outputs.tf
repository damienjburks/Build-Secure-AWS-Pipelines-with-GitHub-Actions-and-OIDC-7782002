# Output Values
# These outputs expose important information about the deployed infrastructure
# They can be accessed via 'terraform output' command or in the GitHub Actions workflow

# Web Server Public IP Output
# Displays the public IP address assigned to the EC2 instance
# This IP address can be used to access the web server directly
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

# Web Server URL Output
# Provides a ready-to-use HTTP URL for accessing the deployed web server
# This is more convenient than manually constructing the URL from the IP address
output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

# VPC ID Output
# Displays the unique identifier of the created VPC
# Useful for reference or if you need to add additional resources to this VPC later
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Vervium UI S3 Bucket
output "vervium_ui_bucket" {
  description = "S3 bucket name hosting the Vervium UI"
  value       = aws_s3_bucket.vervium_ui.id
}

# ============================================================================
# Deployment Identity Outputs
# ============================================================================

# Deployment Method
output "deployment_method" {
  description = "Method used for deployment (OIDC or IAM_USER)"
  value       = local.deployment_method
}

# Caller Identity
output "caller_identity" {
  description = "AWS identity used for deployment"
  value       = local.identity_name
}

# Caller ARN
output "caller_arn" {
  description = "Full ARN of the caller identity"
  value       = data.aws_caller_identity.current.arn
}

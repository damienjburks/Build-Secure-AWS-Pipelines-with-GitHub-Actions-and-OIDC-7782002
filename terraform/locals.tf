# ============================================================================
# Local Values
# Computed values used throughout the configuration
# ============================================================================

locals {
  # Determine deployment method based on ARN pattern
  # IAM Users have ARN pattern: arn:aws:iam::account-id:user/username
  # IAM Roles have ARN pattern: arn:aws:iam::account-id:role/rolename or assumed-role
  is_iam_user       = can(regex(":user/", data.aws_caller_identity.current.arn))
  deployment_method = local.is_iam_user ? "IAM_USER" : "OIDC"
  
  # Extract the identity name (user or role name)
  identity_name = split("/", data.aws_caller_identity.current.arn)[1]
}

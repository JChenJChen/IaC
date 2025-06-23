# 1.1. Create an Admin IAM User and Group (Terraform Equivalent)
resource "aws_iam_group" "admin_group" {
  name = "admin-group"
}

resource "aws_iam_group_policy_attachment" "admin_group_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "admin_user" {
  name = "admin-user-tf"
}

resource "aws_iam_user_group_membership" "admin_membership" {
  user   = aws_iam_user.admin_user.name
  groups = [aws_iam_group.admin_group.name]
}

resource "aws_iam_access_key" "admin_access_key" {
  user = aws_iam_user.admin_user.name
}

output "admin_user_name" {
  description = "Name of the admin user"
  value       = aws_iam_user.admin_user.name
}

output "admin_access_key_id" {
  description = "Access key ID for the admin user"
  value       = aws_iam_access_key.admin_access_key.id
}

output "admin_secret_access_key" {
  description = "Secret access key for the admin user (visible only at creation!)"
  value       = aws_iam_access_key.admin_access_key.secret
  sensitive   = true
}
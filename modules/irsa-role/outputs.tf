output "role_arn" {
  value = aws_iam_role.this.arn
}

output "sa_name" {
  value = var.service_account
}

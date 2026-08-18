output "access_key_id" {
  description = "Access Key do usuário IAM"
  value       = aws_iam_access_key.dev_junior.id
}

output "secret_access_key" {
  description = "Secret Access Key do usuário IAM"
  value       = aws_iam_access_key.dev_junior.secret
  sensitive   = true
}
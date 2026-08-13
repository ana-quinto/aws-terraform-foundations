###############################################
# Outputs
###############################################

output "ip_publico" {
  description = "IP público da instância"
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.web_server.id
}

output "public_dns" {
  description = "DNS público da instância"
  value       = aws_instance.web_server.public_dns
}
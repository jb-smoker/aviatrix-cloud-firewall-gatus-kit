output "aws_dashboard_public_ip" {
  description = "Public IP address of the dashboard instance"
  value       = var.dashboard ? module.dashboard[0].public_ip : null
}

output "aws_local_user_password" {
  value       = var.local_user_password != null ? null : random_password.password[0].result
  sensitive   = true
  description = "The generated random local_user_password"
}

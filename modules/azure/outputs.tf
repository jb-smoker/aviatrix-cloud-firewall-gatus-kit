output "azure_dashboard_public_ip" {
  description = "Public IP address of the dashboard instance"
  value       = var.dashboard ? module.dashboard[0].public_ips.network_interface_1-ip_configuration_1.ip_address : null
}

output "azure_local_user_password" {
  value       = var.local_user_password != null ? null : random_password.password[0].result
  sensitive   = true
  description = "The generated random local_user_password"
}

output "dashboard_public_ip" {
  description = "Public IP address of the dashboard instance"
  value       = var.dashboard ? module.dashboard[0].public_ip : null
}

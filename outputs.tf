output "aws_dashboard_public_ip" {
  value = contains([for s in var.clouds : lower(s)], "aws") ? module.aws["aws"].dashboard_public_ip : null
}

output "azure_dashboard_public_ip" {
  value = contains([for s in var.clouds : lower(s)], "azure") ? module.azure["azure"].dashboard_public_ip : null
}

output "local_user_password" {
  value       = var.local_user_password != null ? var.local_user_password : random_password.password[0].result
  sensitive   = true
  description = "The generated random local_user_password"
}

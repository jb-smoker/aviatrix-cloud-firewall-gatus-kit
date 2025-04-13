output "aws_dashboard_public_ip" {
  description = "Aws Gatus Dasboard Public IP"
  value       = contains([for s in var.clouds : lower(s)], "aws") ? module.aws["aws"].aws_dashboard_public_ip : null
}

output "azure_dashboard_public_ip" {
  description = "Azure Gatus Dasboard Public IP"
  value       = contains([for s in var.clouds : lower(s)], "azure") ? module.azure["azure"].azure_dashboard_public_ip : null
}

output "aws_local_user_password" {
  value       = var.local_user_password != null ? null : module.aws["aws"].aws_local_user_password
  sensitive   = true
  description = "The generated random aws local_user_password"
}

output "azure_local_user_password" {
  value       = var.local_user_password != null ? null : module.azure["azure"].azure_local_user_password
  sensitive   = true
  description = "The generated random azure local_user_password"
}

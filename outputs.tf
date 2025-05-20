output "azure_vnet" {
  description = "The Azure vnet and its outputs"
  value       = contains([for s in var.clouds : lower(s)], "azure") ? module.azure["azure"].azure_vnet : null
}

output "azure_gateway_subnet" {
  description = "The Azure gateway subnet and its outputs"
  value       = contains([for s in var.clouds : lower(s)], "azure") ? module.azure["azure"].azure_gateway_subnet : null
}

output "aws_vpc" {
  description = "The AWS vpc and its outputs"
  value       = contains([for s in var.clouds : lower(s)], "aws") ? module.aws["aws"].aws_vpc : null
}

output "aws_dashboard_public_ip" {
  description = "Aws Gatus Dashboard Public IP"
  value       = contains([for s in var.clouds : lower(s)], "aws") ? module.aws["aws"].aws_dashboard_public_ip : null
}

output "azure_dashboard_public_ip" {
  description = "Azure Gatus Dashboard Public IP"
  value       = contains([for s in var.clouds : lower(s)], "azure") ? module.azure["azure"].azure_dashboard_public_ip : null
}

output "aws_local_user_password" {
  description = "The generated random aws local_user_password"
  value       = contains([for s in var.clouds : lower(s)], "aws") && var.local_user_password == null ? module.aws["aws"].aws_local_user_password : null
  sensitive   = true
}

output "azure_local_user_password" {
  description = "The generated random azure local_user_password"
  value       = contains([for s in var.clouds : lower(s)], "azure") && var.local_user_password == null ? module.azure["azure"].azure_local_user_password : null
  sensitive   = true
}


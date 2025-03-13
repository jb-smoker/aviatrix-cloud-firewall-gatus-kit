output "aws_dashboard_public_ip" {
  value = contains(var.clouds, "aws") ? module.aws["aws"].dashboard_public_ip : null
}

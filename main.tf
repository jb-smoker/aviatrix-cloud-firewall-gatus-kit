data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

resource "random_password" "password" {
  count            = var.local_user_password == null ? 1 : 0
  length           = 12           # Password length
  special          = true         # Include special characters
  override_special = "!#$%&*-_=+" # Specify which special characters to include
  min_lower        = 2            # Minimum lowercase characters
  min_upper        = 2            # Minimum uppercase characters
  min_numeric      = 2            # Minimum numeric characters
  min_special      = 2            # Minimum special characters
}

module "aws" {
  for_each              = contains([for s in var.clouds : lower(s)], "aws") ? toset(["aws"]) : toset([])
  source                = "./aws"
  region                = var.aws_region == null ? "region_placeholder" : var.aws_region
  number_of_instances   = var.number_of_instances
  gatus_endpoints       = var.gatus_endpoints
  gatus_version         = var.gatus_version
  gatus_interval        = var.gatus_interval
  cidr                  = var.aws_cidr
  local_user            = var.local_user
  local_user_password   = var.local_user_password != null ? var.local_user_password : random_password.password[0].result
  dashboard             = var.dashboard
  dashboard_access_cidr = var.dashboard_access_cidr != null ? var.dashboard_access_cidr : "${chomp(data.http.my_ip.response_body)}/32"
}

module "azure" {
  for_each              = contains([for s in var.clouds : lower(s)], "azure") ? toset(["azure"]) : toset([])
  source                = "./azure"
  region                = var.azure_region == null ? "region_placeholder" : var.azure_region
  number_of_instances   = var.number_of_instances
  gatus_endpoints       = var.gatus_endpoints
  gatus_version         = var.gatus_version
  gatus_interval        = var.gatus_interval
  cidr                  = var.azure_cidr
  local_user            = var.local_user
  local_user_password   = var.local_user_password != null ? var.local_user_password : random_password.password[0].result
  dashboard             = var.dashboard
  dashboard_access_cidr = var.dashboard_access_cidr != null ? var.dashboard_access_cidr : "${chomp(data.http.my_ip.response_body)}/32"
}

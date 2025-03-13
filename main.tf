data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

module "aws" {
  for_each            = contains(var.clouds, "aws") ? toset(["aws"]) : toset([])
  source              = "./aws"
  region              = var.aws_region
  number_of_subnets   = var.number_of_subnets
  gatus_endpoints     = var.gatus_endpoints
  gatus_version       = var.gatus_version
  gatus_interval      = var.gatus_interval
  cidr                = var.aws_cidr
  dashboard           = var.dashboard
  dashboard_access_ip = var.dashboard_access_ip != null ? var.dashboard_access_ip : "${chomp(data.http.my_ip.response_body)}/32"
}

module "azure" {
  for_each            = contains(var.clouds, "azure") ? toset(["azure"]) : toset([])
  source              = "./azure"
  region              = var.azure_region
  number_of_subnets   = var.number_of_subnets
  gatus_endpoints     = var.gatus_endpoints
  gatus_version       = var.gatus_version
  gatus_interval      = var.gatus_interval
  cidr                = var.azure_cidr
  dashboard           = var.dashboard
  dashboard_access_ip = var.dashboard_access_ip != null ? var.dashboard_access_ip : "${chomp(data.http.my_ip.response_body)}/32"
}

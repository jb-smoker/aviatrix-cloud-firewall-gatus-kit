variable "aws_region" { default = "us-east-1" }
variable "azure_region" { default = "East US" }

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "azure_subscription_id"
  client_id                       = "azure_application_id"
  client_secret                   = "azure_application_key"
  tenant_id                       = "azure_directory_id"
}

module "demo_spoke_workloads" {
  source                = "github.com/jb-smoker/demo-spoke-workloads"
  clouds                = ["aws", "azure"]
  aws_region            = var.aws_region
  azure_region          = var.azure_region
  aws_cidr              = "10.1.1.0/24"
  azure_cidr            = "10.2.1.0/24"
  dashboard             = true
  dashboard_access_cidr = "0.0.0.0/0" #accessible to the entire internet
  gatus_interval        = "10"        #seconds
  gatus_version         = "5.12.1"
  local_user            = "my_local_user"
  local_user_password   = "my_secret_password"
  number_of_instances   = 2
  gatus_endpoints = {
    https = [
      "aviatrix.com",
      "aws.amazon.com",
      "www.microsoft.com",
      "cloud.google.com",
      "github.com",
      "thishabboforum.com",
      "malware.net",
      "go.dev",
      "dk-metall.ru",
    ]
    http = [
      "de.vu",
      "69298.com",
      "tiktock.com",
      "acrilhacrancon.com",
      "blockexplorer.com",
    ]
    tcp  = []
    icmp = []
  }
}

output "aws_dashboard" {
  value = module.demo_spoke_workloads.aws_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.aws_dashboard_public_ip}" : null
}
output "azure_dashboard" {
  value = module.demo_spoke_workloads.azure_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.azure_dashboard_public_ip}" : null
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
  required_version = ">= 1.5.0"
}

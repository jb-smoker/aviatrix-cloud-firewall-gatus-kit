# Variables
variable "aws_region" {
  default = "us-east-1"
}
variable "azure_region" {
  default = "East US"
}
# Terraform configuration
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.2.1"
    }
  }
}
# Providers
provider "aws" {
  region = var.aws_region
}
provider "azurerm" {
  features {}
}

# Modules
module "aviatrix_cloud_firewall_gatus_kit" {
  source       = "github.com/jb-smoker/aviatrix-cloud-firewall-gatus-kit"
  aws_region   = var.aws_region
  azure_region = var.azure_region
}
# Outputs
output "aws_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip}" : null
}
output "azure_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip}" : null
}

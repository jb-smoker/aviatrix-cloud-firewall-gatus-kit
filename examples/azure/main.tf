# Variables
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
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.2.1"
    }
  }
}
# Providers
provider "azurerm" {
  features {}
}
# Modules
module "aviatrix_cloud_firewall_gatus_kit" {
  source       = "github.com/jb-smoker/aviatrix-cloud-firewall-gatus-kit/modules/azure"
  azure_region = var.azure_region
}
# Outputs
output "azure_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip}" : null
}

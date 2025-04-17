# Azure example

Deployment example for Azure only.

```hcl
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
module "demo_spoke_workloads" {
  source       = "github.com/jb-smoker/demo-spoke-workloads/modules/azure"
  azure_region = var.azure_region
}
# Outputs
output "azure_dashboard" {
  value = module.demo_spoke_workloads.azure_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.azure_dashboard_public_ip}" : null
}
```

# Azure example

Deployment example for Azure only.

```hcl
variable "azure_region" { default = "East US" }

provider "azurerm" {
  features {}
}

module "demo_spoke_workloads" {
  source                = "github.com/jb-smoker/demo-spoke-workloads/modules/azure"
  azure_region          = var.azure_region
}

output "azure_dashboard" {
  value = module.demo_spoke_workloads.azure_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.azure_dashboard_public_ip}" : null
}

terraform {
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
  required_version = ">= 1.5.0"
}
```

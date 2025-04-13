# Azure example with no optional input variables

An Azure-only example with no optional input variables defined.

```hcl
variable "azure_region" { default = "East US" }

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "azure_subscription_id"
  client_id                       = "azure_application_id"
  client_secret                   = "azure_application_key"
  tenant_id                       = "azure_directory_id"
}

module "demo_spoke_workloads" {
  source       = "github.com/jb-smoker/demo-spoke-workloads/modules/azure"
  clouds       = ["azure"]
  azure_region = var.azure_region
}

output "azure_dashboard" {
  value = module.demo_spoke_workloads.azure_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.azure_dashboard_public_ip}" : null
}
output "azure_local_user_password" {
  value     = module.demo_spoke_workloads.azure_local_user_password != null ? module.demo_spoke_workloads.azure_local_user_password : null
  sensitive = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
  required_version = ">= 1.5.0"
}
```

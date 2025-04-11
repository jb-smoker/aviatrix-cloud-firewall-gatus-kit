# Azure example with no optional input variables

Azure-only with no optional input variables

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
  source       = "github.com/jb-smoker/demo-spoke-workloads"
  clouds       = ["azure"]
  azure_region = var.azure_region
}

output "azure_dashboard" {
  value = module.demo_spoke_workloads.azure_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.azure_dashboard_public_ip}" : null
}
output "local_user_password" {
  value     = module.demo_spoke_workloads.local_user_password != null ? module.demo_spoke_workloads.local_user_password : null
  sensitive = true
}
```

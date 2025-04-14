# All supported clouds example with no optional input variables

An example of all supported clouds with no optional input variables defined.

```hcl
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
  source       = "github.com/jb-smoker/demo-spoke-workloads"
  clouds       = ["aws", "azure"]
  aws_region   = var.aws_region
  azure_region = var.azure_region
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
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.2.1"
    }
  }
  required_version = ">= 1.5.0"
}
```

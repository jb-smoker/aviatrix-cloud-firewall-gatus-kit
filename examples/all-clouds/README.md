# All supported clouds example

Deployment example of all supported clouds.

```hcl
variable "aws_region" { default = "us-east-1" }
variable "azure_region" { default = "East US" }

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

module "aviatrix_cloud_firewall_gatus_kit" {
  source       = "github.com/jb-smoker/aviatrix-cloud-firewall-gatus-kit"
  aws_region   = var.aws_region
  azure_region = var.azure_region
}

output "aws_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip}" : null
}
output "azure_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.azure_dashboard_public_ip}" : null
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

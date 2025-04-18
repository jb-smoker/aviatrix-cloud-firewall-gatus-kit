# AWS example

Deployment example for AWS only.

```hcl
# Variables
variable "aws_region" {
  default = "us-east-1"
}
# Terraform configuration
terraform {
  required_version = ">= 1.5.0"

  required_providers {
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
# Modules
module "aviatrix_cloud_firewall_gatus_kit" {
  source     = "github.com/jb-smoker/aviatrix-cloud-firewall-gatus-kit/modules/aws"
  aws_region = var.aws_region
}
# Outputs
output "aws_dashboard" {
  value = module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip != null ? "http://${module.aviatrix_cloud_firewall_gatus_kit.aws_dashboard_public_ip}" : null
}
```

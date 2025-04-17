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
module "demo_spoke_workloads" {
  source     = "github.com/jb-smoker/demo-spoke-workloads/modules/aws"
  aws_region = var.aws_region
}
# Outputs
output "aws_dashboard" {
  value = module.demo_spoke_workloads.aws_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.aws_dashboard_public_ip}" : null
}
```

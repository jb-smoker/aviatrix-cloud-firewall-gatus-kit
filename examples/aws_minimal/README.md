# Aws example with no optional input variables

An Aws-only example with no optional input variables defined.

```hcl
variable "aws_region" { default = "us-east-1" }

provider "aws" {
  region = var.aws_region
}

module "demo_spoke_workloads" {
  source     = "github.com/jb-smoker/demo-spoke-workloads/modules/aws"
  clouds     = ["aws"]
  aws_region = var.aws_region
}

output "aws_dashboard" {
  value = module.demo_spoke_workloads.aws_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.aws_dashboard_public_ip}" : null
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94"
    }
  }
  required_version = ">= 1.5.0"
}
```

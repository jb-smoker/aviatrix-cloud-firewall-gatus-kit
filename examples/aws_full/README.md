# Aws example with all input variables

An Aws-only example with all input variables defined.

```hcl
variable "aws_region" { default = "us-east-1" }

provider "aws" {
  region = var.aws_region
}

module "demo_spoke_workloads" {
  source                = "github.com/jb-smoker/demo-spoke-workloads/modules/aws"
  clouds                = ["aws"]
  aws_region            = var.aws_region
  aws_cidr              = "10.1.1.0/24"
  dashboard             = true
  dashboard_access_cidr = "0.0.0.0/0" #accessible to the entire internet
  gatus_interval        = "10"        #seconds
  gatus_version         = "5.12.1"
  local_user            = "my_local_user"
  local_user_password   = "my_secret_password"
  number_of_instances   = 2
  gatus_endpoints = {
    https = [
      "aviatrix.com",
      "aws.amazon.com",
      "www.microsoft.com",
      "cloud.google.com",
      "github.com",
      "thishabboforum.com",
      "malware.net",
      "go.dev",
      "dk-metall.ru",
    ]
    http = [
      "de.vu",
      "69298.com",
      "tiktock.com",
      "acrilhacrancon.com",
      "blockexplorer.com",
    ]
    tcp  = []
    icmp = []
  }
}

output "aws_dashboard" {
  value = module.demo_spoke_workloads.aws_dashboard_public_ip != null ? "http://${module.demo_spoke_workloads.aws_dashboard_public_ip}" : null
}
```

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
output "aws_local_user_password" {
  value     = module.demo_spoke_workloads.aws_local_user_password != null ? module.demo_spoke_workloads.aws_local_user_password : null
  sensitive = true
}

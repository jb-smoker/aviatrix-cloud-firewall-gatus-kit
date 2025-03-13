variable "region" {
  description = "AWS region"
  type        = string
}

variable "number_of_subnets" {
  description = "Number of subnets and workload instances to create"
  type        = number
}

variable "gatus_endpoints" {
  description = "Gatus endpoints to test"
  type        = map(list(string))
}

variable "gatus_interval" {
  description = "Gatus polling interval"
  type        = number
}

variable "gatus_version" {
  description = "Gatus polling interval"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "dashboard" {
  description = "Create a dashboard to expose gatus status to the Internet"
  type        = bool
}

variable "dashboard_access_ip" {
  description = "IP address to allow access to the dashboard"
  type        = string
}

locals {
  az_suffixes     = ["a", "b", "c", "d", "e", "f"]
  azs             = [for i in range(var.number_of_subnets) : "${var.region}${local.az_suffixes[i % length(local.az_suffixes)]}"]
  subnets         = cidrsubnets(var.cidr, [for i in range(var.number_of_subnets * 2) : "4"]...)
  private_subnets = slice(local.subnets, 0, var.number_of_subnets)
  public_subnets  = slice(local.subnets, var.number_of_subnets, var.number_of_subnets * 2)
}

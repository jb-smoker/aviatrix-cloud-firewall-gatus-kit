variable "region" {
  description = "AWS region"
  type        = string
  validation {
    condition     = contains(data.aws_regions.available.names, var.region)
    error_message = "AWS region must be specified and valid when AWS is included in the clouds list."
  }
}

variable "number_of_instances" {
  description = "Number of gatus instances spread across subnets/azs to create"
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

variable "local_user" {
  description = "Local user to create on the gatus instances"
  type        = string
}

variable "local_user_password" {
  description = "Password for the local user on the gatus instances"
  type        = string
}

variable "dashboard" {
  description = "Create a dashboard to expose gatus status to the Internet"
  type        = bool
}

variable "dashboard_access_cidr" {
  description = "CIDR that has http access to the dashboard(s)"
  type        = string
  validation {
    condition     = can(cidrhost(var.dashboard_access_cidr, 0))
    error_message = "dashboard_access_cidr must be valid IPv4 CIDR."
  }
}

locals {
  az_suffixes     = ["a", "b", "c"]
  azs             = [for i in range(var.number_of_instances) : "${var.region}${local.az_suffixes[i % length(local.az_suffixes)]}"]
  subnets         = cidrsubnets(var.cidr, [for i in range(var.number_of_instances * 2) : "4"]...)
  private_subnets = slice(local.subnets, 0, var.number_of_instances)
  public_subnets  = slice(local.subnets, var.number_of_instances, var.number_of_instances * 2)
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  validation {
    condition     = contains(data.aws_regions.available.names, var.aws_region)
    error_message = "AWS region must be specified and valid when AWS is included in the clouds list."
  }
}

variable "aws_cidr" {
  description = "Aws vpc cidr."
  type        = string
  default     = "10.1.0.0/24"
  validation {
    condition     = can(cidrhost(var.aws_cidr, 0))
    error_message = "aws_cidr must be valid IPv4 CIDR."
  }
}

variable "number_of_instances" {
  description = "Number of gatus instances spread across subnets/azs to create."
  type        = number
  default     = 2
  validation {
    condition = (
      var.number_of_instances <= 3 &&
      var.number_of_instances >= 1
    )
    error_message = "number_of_instances must be between 1 and 3."
  }
}

variable "gatus_interval" {
  description = "Gatus polling interval."
  type        = number
  default     = 10
}

variable "gatus_version" {
  description = "Gatus version."
  type        = string
  default     = "5.12.1"
}

variable "gatus_endpoints" {
  description = "Gatus endpoints to test."
  type        = map(list(string))
  default = {
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

variable "local_user" {
  description = "Local user to create on the gatus instances."
  type        = string
  default     = "gatus"
}

variable "local_user_password" {
  description = "Password for the local user on the gatus instances."
  type        = string
  default     = null
}

variable "dashboard" {
  description = "Create a dashboard to expose gatus status to the Internet."
  type        = bool
  default     = true
}

variable "dashboard_access_cidr" {
  description = "CIDR that has http access to the dashboard(s)."
  type        = string
  default     = null
  validation {
    condition     = var.dashboard_access_cidr == null ? true : can(cidrhost(var.dashboard_access_cidr, 0))
    error_message = "dashboard_access_cidr must be valid IPv4 CIDR."
  }
}

locals {
  az_suffixes     = ["a", "b", "c"]
  azs             = [for i in range(var.number_of_instances) : "${var.aws_region}${local.az_suffixes[i % length(local.az_suffixes)]}"]
  subnets         = cidrsubnets(var.aws_cidr, [for i in range(var.number_of_instances * 2) : "4"]...)
  private_subnets = slice(local.subnets, 0, var.number_of_instances)
  public_subnets  = slice(local.subnets, var.number_of_instances, var.number_of_instances * 2)
}

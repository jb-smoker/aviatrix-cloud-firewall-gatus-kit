variable "clouds" {
  description = "Deploy gatus workloads to these cloud provider(s)."
  type        = list(string)
  validation {
    condition = length([
      for cloud in var.clouds : true
      if contains(["aws", "azure"], lower(cloud))
    ]) == length(var.clouds)
    error_message = "This module only supports Aws and Azure."
  }
}


variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = null
}

variable "azure_region" {
  description = "Azure region."
  type        = string
  default     = null
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

variable "aws_cidr" {
  description = "Aws vpc cidr."
  type        = string
  default     = "10.1.0.0/24"
  validation {
    condition     = can(cidrhost(var.aws_cidr, 0))
    error_message = "aws_cidr must be valid IPv4 CIDR."
  }
}

variable "azure_cidr" {
  description = "Azure vpc cidr."
  type        = string
  default     = "10.2.0.0/24"
  validation {
    condition     = can(cidrhost(var.azure_cidr, 0))
    error_message = "azure_cidr must be valid IPv4 CIDR."
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
  default     = false
}

variable "dashboard_access_cidr" {
  description = "CIDR that has http access to the dashboard(s)."
  type        = string
  default     = null
}

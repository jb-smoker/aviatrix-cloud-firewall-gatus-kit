variable "clouds" {
  description = "Cloud provider(s) to deploy"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "Central US"
}

variable "number_of_subnets" {
  description = "Number of subnets and workload instances to create"
  type        = number
  default     = 2
}

variable "aws_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.1.0.0/24"
}

variable "azure_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.2.0.0/24"
}

variable "gatus_interval" {
  description = "Gatus polling interval"
  type        = number
  default     = 10
}

variable "gatus_version" {
  description = "Gatus version"
  type        = string
  default     = "5.12.1"
}

variable "gatus_endpoints" {
  description = "Gatus endpoints to test"
  type        = map(list(string))
  default = {
    https = [
      "malware.net",
      "botnet.com",
      "ransomware.org",
      "aviatrix.com",
      "www.microsoft.com",
      "cloud.google.com",
      "aws.amazon.com",
      "www.oracle.com/cloud/sign-in.html",
    ]
    http = [
      "tiktock.com",
      "aviatrix.com",
      "www.microsoft.com",
    ]
    tcp  = []
    icmp = []
  }
}

variable "dashboard" {
  description = "Create a dashboard to expose gatus status to the Internet"
  type        = bool
  default     = false
}

variable "dashboard_access_ip" {
  description = "IP address to allow access to the dashboard"
  type        = string
  default     = null
}

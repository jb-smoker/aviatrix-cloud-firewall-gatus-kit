terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.94"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">= 1.2.1"
    }
  }
  required_version = ">= 1.5.0"
}

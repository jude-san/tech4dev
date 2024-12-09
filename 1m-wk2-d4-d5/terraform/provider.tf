terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    # datadog = {
    #   source  = "DataDog/datadog"
    # }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "tech4dev"
}

# provider "datadog" {
#   api_key = var.datadog_api_key
#   app_key = var.datadog_app_key
# }

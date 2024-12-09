variable "datadog_api_key" {
  description = "Datadog API Key"
  default     = ""
}

variable "datadog_app_key" {
  description = "Datadog APP Key"
  default     = ""
}

variable "datadog_dashboard_title" {
  description = "Datadog Dashboard Title"
  default     = "Tech4Dev Dashboard"
}

variable "base_name" {
  description = "Base name for resources"
  default     = "tech4dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnet"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

variable "key_name" {
  description = "Key pair name"
  default     = "tech4dev"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

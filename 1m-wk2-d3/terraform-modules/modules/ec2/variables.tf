# General Variables
variable "name" {
  description = "Base name for all resources"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet Variables
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "public_ip" {
  description = "Whether to assign a public IP to instances in this subnet"
  type        = bool
  default     = false
}

# EC2 Instance Variables
variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

# IAM Variables
variable "assume_role_policy" {
  description = "IAM assume role policy document"
  type        = string
}

variable "policy_arn" {
  description = "Policy ARN to attach to the IAM role"
  type        = string
}

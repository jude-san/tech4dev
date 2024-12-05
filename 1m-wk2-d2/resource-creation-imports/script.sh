#! /bin/bash

# Configure access key and secret key using the aws cli
aws configure

# Regular terraform commands
terraform init
terraform plan
terraform apply

# View terraform state data.
terraform state list
terraform state show aws_instance.tech4dev1

# Automatically generate code snippet for resources to import
terraform plan -generate-config-out=generated.tf

# Generate a dependency graph for your terraform code (dot utility is required)
terraform graph | dot -Tsvg > graph.svg

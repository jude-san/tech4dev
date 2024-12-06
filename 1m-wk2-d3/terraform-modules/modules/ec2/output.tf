output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID of the created Subnet"
  value       = aws_subnet.this.id
}

output "iam_role_name" {
  description = "Name of the created IAM Role"
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "Name of the created IAM Instance Profile"
  value       = aws_iam_instance_profile.this.name
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

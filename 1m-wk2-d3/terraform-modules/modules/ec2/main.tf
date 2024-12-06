# Create a VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name = "${var.name}-vpc"
  }, var.tags)
}

# Create a Subnet
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = var.public_ip
  availability_zone       = var.availability_zone
  tags = merge({
    Name = "${var.name}-subnet"
  }, var.tags)
}

# Create IAM Role for the Instance
resource "aws_iam_role" "this" {
  name               = "${var.name}-role"
  assume_role_policy = var.assume_role_policy

  tags = merge({
    Name = "${var.name}-role"
  }, var.tags)
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}

# Create Instance Profile
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.this.name
}

# Create the EC2 Instance
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.this.id

  iam_instance_profile = aws_iam_instance_profile.this.name

  tags = merge({
    Name = "${var.name}-instance"
  }, var.tags)
}

module "ec2_instance" {
  source = "./modules/ec2"

  name                 = "tech4dev"
  vpc_cidr             = "10.0.0.0/16"
  subnet_cidr          = "10.0.1.0/24"
  availability_zone    = "us-east-1a"
  public_ip            = false
  ami                  = "ami-0866a3c8686eaeeba" # Example AMI ID
  instance_type        = "t2.micro"
  key_name             = "my-keypair"
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}

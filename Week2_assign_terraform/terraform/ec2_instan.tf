module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.16.0"
  name            = "tech4dev"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-2a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]
}

module "security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.2.0"
  name                = "tech4dev"
  description         = "Security group for tech4dev web and ansible"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.7.1"
  name                        = "tech4dev"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  availability_zone           = "eu-west-2a"
  vpc_security_group_ids      = [module.security-group.security_group_id]
  ami                         = "ami-0c76bd4bd302b30ec"
  key_name                    = "static-webapp"
  associate_public_ip_address = true
  user_data                   = file("script.sh")
  tags = {
    Name = "nginx"
  }
}

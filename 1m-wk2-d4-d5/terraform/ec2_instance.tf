module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.16.0"
  name            = var.base_name
  cidr            = var.cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "web-security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.2.0"
  name                = var.base_name
  description         = "Security group for tech4dev web and ansible"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "proxy-security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.2.0"
  name                = "${var.base_name}-proxy"
  description         = "Security group for tech4dev proxy"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "web_servers" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.7.1"
  for_each                    = toset(["one", "two"])
  name                        = "web-${each.key}"
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  availability_zone           = var.availability_zones[0]
  vpc_security_group_ids      = [module.web-security-group.security_group_id]
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name        = "web-${each.key}",
    Environment = "dev"
    Role        = "web"
  }
}

module "proxy_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.7.1"
  name                        = "proxy"
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  availability_zone           = var.availability_zones[0]
  vpc_security_group_ids      = [module.proxy-security-group.security_group_id]
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name        = "proxy",
    Environment = "dev"
    Role        = "loadbalancer"
  }
}

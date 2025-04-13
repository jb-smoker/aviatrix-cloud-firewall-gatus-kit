data "aws_regions" "available" {}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

resource "random_password" "password" {
  count            = var.local_user_password == null ? 1 : 0
  length           = 12           # Password length
  special          = true         # Include special characters
  override_special = "!#$%&*-_=+" # Specify which special characters to include
  min_lower        = 2            # Minimum lowercase characters
  min_upper        = 2            # Minimum uppercase characters
  min_numeric      = 2            # Minimum numeric characters
  min_special      = 2            # Minimum special characters
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "aviatrix"
  cidr = var.aws_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
}

resource "aws_security_group" "this" {
  name        = "aviatrix"
  description = "security group for aviatrix gatus instances"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "this_ingress" {
  type              = "ingress"
  description       = "Allow inbound http access"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_dashboard" {
  count             = var.dashboard ? 1 : 0
  type              = "ingress"
  description       = "Allow inbound internet http access"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.dashboard_access_cidr != null ? [var.dashboard_access_cidr] : ["${chomp(data.http.my_ip.response_body)}/32"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_egress" {
  type              = "egress"
  description       = "Allow outbound access"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

module "gatus" {
  for_each = toset(formatlist("%d", range(var.number_of_instances)))
  source   = "terraform-aws-modules/ec2-instance/aws"

  name = "aviatrix-aws-gatus-az${each.value + 1}"

  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = element(module.vpc.private_subnets, each.key)
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value

  user_data = templatefile("${path.module}/templates/gatus.tpl",
    {
      name     = "aviatrix-aws-gatus-az${each.value + 1}"
      user     = var.local_user
      password = var.local_user_password != null ? var.local_user_password : random_password.password[0].result
      https    = var.gatus_endpoints.https
      http     = var.gatus_endpoints.http
      tcp      = var.gatus_endpoints.tcp
      icmp     = var.gatus_endpoints.icmp
      interval = var.gatus_interval
      version  = var.gatus_version
  })
  depends_on = [module.vpc]
}

module "dashboard" {
  count  = var.dashboard ? 1 : 0
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "aviatrix-aws-gatus-dashboard"

  instance_type               = "t3.nano"
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = module.vpc.public_subnets[0]
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/dashboard.tpl",
    {
      cloud     = "aws"
      instances = [for instance in module.gatus : instance.private_ip]
      version   = var.gatus_version
  })
  depends_on = [module.gatus]
}

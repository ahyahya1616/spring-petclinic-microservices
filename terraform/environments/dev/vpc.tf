module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # Cost Optimization: Single NAT Gateway shared across private subnets
  # Saves ~$32/month per additional NAT Gateway to preserve your $200 AWS credit budget
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  # AWS ALB Ingress Controller subnet discovery tags
  # Only public subnets need 'kubernetes.io/role/elb = 1' for external ALBs.
  # Internal microservice communication uses Kubernetes ClusterIP / CoreDNS overlay.
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Type"                                      = "Public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Type"                                      = "Private"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

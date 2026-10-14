aws_region   = "eu-west-1"
environment  = "dev"
project_name = "petclinic"

# EKS Configuration
cluster_name        = "petclinic-eks"
cluster_version     = "1.35"
node_capacity_type  = "SPOT" # Maximize cost-savings for free-tier / credits
node_instance_types = ["t3.large"]
node_min_size       = 2
node_max_size       = 4
node_desired_size   = 2

# Network Configuration (2 AZs, 2 public & 2 private per AZ)
vpc_cidr = "10.0.0.0/16"
azs      = ["eu-west-1a", "eu-west-1b"]

public_subnets = [
  "10.0.1.0/24", # AZ-a ALB Ingress
  "10.0.2.0/24", # AZ-b ALB Ingress
  "10.0.3.0/24", # AZ-a NAT / Egress
  "10.0.4.0/24"  # AZ-b NAT / Egress
]

private_subnets = [
  "10.0.11.0/24", # AZ-a Microservices Workloads
  "10.0.12.0/24", # AZ-b Microservices Workloads
  "10.0.13.0/24", # AZ-a Data / Internal
  "10.0.14.0/24"  # AZ-b Data / Internal
]

# ECR Repositories for Spring PetClinic Microservices
ecr_repositories = [
  "petclinic-api-gateway",
  "petclinic-customers-service",
  "petclinic-vets-service",
  "petclinic-visits-service",
  "petclinic-genai-service"
]

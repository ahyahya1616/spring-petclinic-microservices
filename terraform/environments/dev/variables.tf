variable "aws_region" {
  description = "The AWS region where resources will be provisioned"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Base project name used for resource naming and tagging"
  type        = string
  default     = "petclinic"
}

variable "vpc_cidr" {
  description = "CIDR block for the Virtual Private Cloud (VPC)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to distribute subnets across (2 AZs)"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs: 2 public subnets per AZ (4 total: Ingress & NAT/Egress)"
  type        = list(string)
  default = [
    "10.0.1.0/24", # Public AZ-a (ALB Ingress)
    "10.0.2.0/24", # Public AZ-b (ALB Ingress)
    "10.0.3.0/24", # Public AZ-a (NAT / Egress)
    "10.0.4.0/24"  # Public AZ-b (NAT / Egress)
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDRs: 2 private subnets per AZ (4 total: Workloads & Data)"
  type        = list(string)
  default = [
    "10.0.11.0/24", # Private AZ-a (EKS Worker Nodes / Microservices)
    "10.0.12.0/24", # Private AZ-b (EKS Worker Nodes / Microservices)
    "10.0.13.0/24", # Private AZ-a (Data / Internal)
    "10.0.14.0/24"  # Private AZ-b (Data / Internal)
  ]
}

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster"
  type        = string
  default     = "petclinic-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.35"
}

variable "node_capacity_type" {
  description = "Capacity type for worker nodes: SPOT (cost-optimized, free tier / credit friendly) or ON_DEMAND"
  type        = string
  default     = "SPOT"
  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.node_capacity_type)
    error_message = "node_capacity_type must be either 'SPOT' or 'ON_DEMAND'."
  }
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_min_size" {
  description = "Minimum number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes in the node group"
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "ecr_repositories" {
  description = "List of ECR repository names to create for the Spring PetClinic microservices"
  type        = list(string)
  default = [
    "petclinic-api-gateway",
    "petclinic-customers-service",
    "petclinic-vets-service",
    "petclinic-visits-service",
    "petclinic-genai-service"
  ]
}

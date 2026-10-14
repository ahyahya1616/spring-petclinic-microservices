module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Enable public endpoint access so kubectl / ArgoCD / Helm can communicate with the cluster
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Automatically grant the IAM entity applying Terraform cluster administrator rights
  # via the modern EKS Access Entries API (replaces legacy aws-auth ConfigMap)
  enable_cluster_creator_admin_permissions = true

  # Managed EKS Add-ons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # Managed Node Group: runs in private subnets with Spot instance capability
  eks_managed_node_groups = {
    petclinic_nodes = {
      name           = "${var.project_name}-node-group"
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type # "SPOT" for maximum cost savings, can switch to "ON_DEMAND"

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      # Place worker nodes strictly into the private workload subnets
      subnet_ids = slice(module.vpc.private_subnets, 0, 2)

      labels = {
        role        = "workload"
        Environment = var.environment
      }

      tags = {
        Environment = var.environment
        Project     = var.project_name
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

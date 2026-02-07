module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.2"

  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version

  # Public access to cluster endpoint (for kubectl)
  cluster_endpoint_public_access = true

  # Networking
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids               # Private Subnets (Nodes)
  control_plane_subnet_ids = var.control_plane_subnet_ids # Public+Private (Control Plane)

  # Access
  enable_cluster_creator_admin_permissions = true

  # Add-ons
  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  # Node Groups
  eks_managed_node_groups = {
    main = {
      name = "${var.cluster_name}-node-group"

      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      
      # Ensure nodes are in private subnets
      subnet_ids     = var.subnet_ids
    }
  }

  tags = var.tags
}
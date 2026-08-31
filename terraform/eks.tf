module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.project_name}-${var.environment}"
  kubernetes_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  endpoint_public_access  = true
  endpoint_private_access = true

  eks_managed_node_groups = {
    main = {
      name = "rp-dev-nodes"

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      labels = {
        Environment = var.environment
        Project     = var.project_name
      }
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

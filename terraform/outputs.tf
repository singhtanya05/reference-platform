output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
  description = "Push images here once CI is switched from GHCR to ECR."
  value       = aws_ecr_repository.reference_platform.repository_url
}

output "lb_controller_role_arn" {
  description = "Pass this to the AWS Load Balancer Controller Helm install as controller.serviceAccount.annotations.\"eks.amazonaws.com/role-arn\"."
  value       = module.lb_controller_irsa.iam_role_arn
}

# IAM role for the AWS Load Balancer Controller, scoped via IRSA to only the
# service account it runs as. The controller itself is still installed via
# Helm/kubectl (not Terraform) — this just makes the IAM half of that setup
# reproducible instead of having been created by hand with `aws iam` calls.
#
# The permissions (attach_load_balancer_controller_policy) match the policy
# that used to live only as a manually-applied iam-policy.json in this repo.
module "lb_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project_name}-${var.environment}-lb-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

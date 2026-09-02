# NOTE: CI currently pushes to GHCR (ghcr.io/singhtanya05/reference-platform),
# not here. This repository exists so ECR is reproducible via Terraform
# instead of having been created by hand in the console — switching CI (and
# the kustomize overlay) to push/pull from here is a separate, deliberate step.
resource "aws_ecr_repository" "reference_platform" {
  name = var.project_name

  # MUTABLE (not IMMUTABLE) because the current CI workflow re-pushes the
  # ":latest" tag on every build. Move to IMMUTABLE once CI stops doing that
  # and relies purely on the per-commit-SHA tag.
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Keep the last 10 images and expire anything untagged after 7 days, so the
# repository doesn't grow (and cost) unbounded from every CI build.
resource "aws_ecr_lifecycle_policy" "reference_platform" {
  repository = aws_ecr_repository.reference_platform.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep only the last 10 images overall"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = { type = "expire" }
      }
    ]
  })
}

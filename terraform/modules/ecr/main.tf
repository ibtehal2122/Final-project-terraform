module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6"

  # Create a repo for each name in the list (backend & frontend)
  for_each = toset(var.repository_names)

  repository_name = each.key

  # Security: Scan images for CVEs on push
  repository_image_scan_on_push = true
  repository_type               = "private"

  # Cost: Automatically delete untagged images after 14 days
  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire untagged images older than 14 days",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 14
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}
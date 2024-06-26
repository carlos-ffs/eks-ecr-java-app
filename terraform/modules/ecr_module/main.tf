provider "aws" {
  region = var.module_region
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.module_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
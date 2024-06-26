output "repo_name" {
  description = "ECR Name"
  value       = aws_ecr_repository.ecr_repo.name
}

output "repo_url" {
  description = "ECR repository url"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "repo_id" {
  description = "ECR  ID"
  value       = aws_ecr_repository.ecr_repo.id
}
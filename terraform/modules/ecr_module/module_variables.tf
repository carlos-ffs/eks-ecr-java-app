variable "module_region" {
  description = "aws region"
  type        = string
  default = "eu-west-2"
}


variable "module_ecr_name" {
  description = "ECR name"
  type        = string
  default = "ecr-cs"
}